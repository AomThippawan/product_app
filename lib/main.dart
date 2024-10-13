import 'package:flutter/material.dart';
import 'package:product_app/pages/login.dart';
import 'package:product_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'product app',
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}
