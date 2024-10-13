import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_app/controllers/auth_controller.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/provider/user_provider.dart';
import 'package:product_app/varibles.dart';

class productSurvice {
  //get product
  Future<void> _response(
      http.Response response, UserProvider userProvider) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 403) {
      await AuthSurvice().refreshToken(userProvider);
    } else if (response.statusCode == 401) {
      userProvider.onlogout();
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error : ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<ProductModel>> fetchProducts(UserProvider userProvider) async {
    final response = await http.get(Uri.parse('$apiURL/api/product'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userProvider.accessToken}',
    });

    await _response(response, userProvider);

    List<dynamic> productList = jsonDecode(response.body);
    return productList.map((json) => ProductModel.fromJson(json)).toList();
  }

  //add product
  Future<void> addProduct(
      ProductModel productModel, UserProvider userProvider) async {
    final response = await http.post(Uri.parse('$apiURL/api/product'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
        body: jsonEncode(productModel.toJson()));
    await _response(response, userProvider);
  }

  //update product
  Future<void> updateProduct(
      ProductModel productModel, UserProvider userProvider) async {
    final response =
        await http.put(Uri.parse('$apiURL/api/product/${productModel.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${userProvider.accessToken}',
            },
            body: jsonEncode(productModel.toJson()));
    await _response(response, userProvider);
  }

  //delete product
  Future<void> deleteProduct(
      String product_id, UserProvider userProvider) async {
    final response = await http.delete(
      Uri.parse('$apiURL/api/product/${product_id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.accessToken}',
      },
    );
    await _response(response, userProvider);
  }
}
