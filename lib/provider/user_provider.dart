import 'package:flutter/material.dart';
import 'package:product_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User get user => _user!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  void onlogin(UserModel userModel) {
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners();
  }

  void onlogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  bool isAuthentication() {
    return _accessToken != null && _refreshToken != null;
  }

  void requestToken(String newToken) {
    _accessToken = newToken;
    notifyListeners();
  }
}
