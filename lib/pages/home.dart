import 'package:flutter/material.dart';
import 'package:product_app/controllers/product_controller.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/pages/addProduct.dart';
import 'package:product_app/pages/updateProduct.dart';
import 'package:product_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel> products = [];
  final productSurvice _productSurvice = productSurvice();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final productList = await _productSurvice.fetchProducts(userProvider);
      setState(() {
        products = productList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching products: $e')));
    }
  }

  void _logout() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onlogout();

    if (!userProvider.isAuthentication()) {
      print('logout successful');
    }

    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _toAddProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProduct(),
      ),
    );
    if (result == true) {
      _fetchProducts();
    }
  }

  void _toUpdateProduct(ProductModel productModel) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateProduct(product: productModel),
      ),
    );
    if (result == true) {
      _fetchProducts();
    }
  }

  Future<void> _deleteProduct(ProductModel productModel) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm deletion'),
          content: Text(
              'Are you sure you want to delete "${productModel.productName}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _productSurvice.deleteProduct(productModel.id, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully!')),
        );
        _fetchProducts(); // อัปเดตข้อมูล
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // print('Access Token: ${userProvider.accessToken}');
    // print('Refresh Token: ${userProvider.refreshToken}');
    // debugPrint('Access Token: ${userProvider.accessToken}');
    // debugPrint('Refresh Token: ${userProvider.refreshToken}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 236, 223),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (userProvider.isAuthentication())
                Text(
                  'Hi ${userProvider.user.name} !',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Text('Access Token: \n${userProvider.accessToken}'),
              Text('Refresh Token: \n${userProvider.refreshToken}'),
              if (products.isEmpty)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productName),
                              SizedBox(
                                height: 5,
                              ),
                              Text('TYPE  : ${product.productType}'),
                              SizedBox(
                                height: 5,
                              ),
                              Text('PRICE : ${product.price}'),
                              SizedBox(
                                height: 5,
                              ),
                              Text('UNIT  : ${product.unit}'),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => _toUpdateProduct(product),
                                    icon: Icon(Icons.edit_note_rounded),
                                    tooltip: 'Edit Product',
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteProduct(product),
                                    icon: Icon(Icons.delete_outline),
                                    tooltip: 'Delete Product',
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toAddProduct,
        child: Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }
}
