import 'package:flutter/material.dart';
import 'package:product_app/controllers/product_controller.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UpdateProduct extends StatefulWidget {
  final ProductModel product;

  UpdateProduct({required this.product});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formkey = GlobalKey<FormState>();
  final productSurvice _productSurvice = productSurvice();

  late String _productName;
  late String _productType;
  late int _price;
  late String _unit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productName = widget.product.productName;
    _productType = widget.product.productType;
    _price = widget.product.price;
    _unit = widget.product.unit;
  }

  void _UpdateProduct() async {
    if (_formkey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final updateProduct = ProductModel(
          productName: widget.product.productName,
          productType: widget.product.productType,
          price: widget.product.price,
          unit: widget.product.unit,
          id: widget.product.id);

      try {
        await _productSurvice.updateProduct(updateProduct, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'EDIT PRODUCT',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          initialValue: _productName,
                          decoration:
                              InputDecoration(labelText: 'PRODUCT NAME'),
                          onChanged: (value) {
                            _productName = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a product name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _productType,
                          decoration:
                              InputDecoration(labelText: 'PRODUCT TYPE'),
                          onChanged: (value) {
                            _productType = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a product type';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _price.toString(),
                          decoration: InputDecoration(labelText: 'PRICE'),
                          onChanged: (value) {
                            _price = int.tryParse(value) ?? 0;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _unit,
                          decoration: InputDecoration(labelText: 'UNIT'),
                          onChanged: (value) {
                            _unit = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a unit';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 80),
                        ElevatedButton(
                          onPressed: _UpdateProduct,
                          child: Text('EDIT'),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
