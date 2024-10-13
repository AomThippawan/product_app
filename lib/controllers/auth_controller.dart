import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/provider/user_provider.dart';
import 'package:product_app/varibles.dart';

class AuthSurvice {
  //login
  Future<UserModel?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print('Login false : ${response.body}');
      return null;
    }
  }

  //register
  Future<void> register(
      String username, String password, String name, String role) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'name': name,
        'role': role
      }),
    );
    print(response.statusCode);
  }

  //refresh
  Future<void> refreshToken(UserProvider userProvider) async {
    final refreshToken = userProvider.refreshToken;

    if (refreshToken == null) {
      throw Exception('Refresh token is null');
    }

    final response = await http.post(
      Uri.parse('$apiURL/api/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': refreshToken,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      userProvider.requestToken(responseData['accessToken']);
    } else {
      print('Failed to refresh token : ${response.body}');
      throw Exception('Failed to refresh token : ${response.body}');
    }
  }
}
