import 'package:flutter/material.dart';
import 'package:product_app/controllers/auth_controller.dart';
import 'package:product_app/pages/home.dart';
import 'package:product_app/pages/register.dart';
import 'package:product_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _authService = AuthSurvice();

  void _login(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      final userModel = await _authService.login(
          _usernameController.text, _passwordController.text);

      if (userModel != null) {
        Provider.of<UserProvider>(context, listen: false).onlogin(userModel);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // รูปภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_login.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.all(15),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'USERNAME'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'PASSWORD'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 10) {
                            return 'Password must be at least 10 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 35, 2, 114),
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            )),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        child: Text('LOGIN'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
