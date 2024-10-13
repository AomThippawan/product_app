import 'package:flutter/material.dart';
import 'package:product_app/controllers/product_controller.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formkey = GlobalKey<FormState>();
  final productSurvice _productSurvice = productSurvice();

  String _productName = '';
  String _productType = '';
  int _price = 0;
  String _unit = '';

  void _AddProduct() async {
    if (_formkey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final NewProduct = ProductModel(
          productName: _productName,
          productType: _productType,
          price: _price,
          unit: _unit,
          id: '');

      try {
        await _productSurvice.addProduct(NewProduct, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );
        // ไปยังหน้า HomePage หลังจากเพิ่มผลิตภัณฑ์สำเร็จ
        Navigator.of(context).pop(
            true); // หรือใช้ Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
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
            image: AssetImage("assets/bg_edit.png"),
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
                          'ADD PRODUCT',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
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
                          decoration: InputDecoration(labelText: 'PRICE'),
                          keyboardType: TextInputType.number,
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
                          onPressed: _AddProduct,
                          child: Text('ADD'),
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
