import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../screens/signup.dart';

class Login extends GetWidget<AuthController> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: _emailController,
              ),
              SizedBox(
                height: 40.0,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                controller: _passwordController,
              ),
              RaisedButton(
                onPressed: () {
                  Get.find<AuthController>().login(
                      _emailController.text, _passwordController.text); // !
                },
                child: Text('Log In'),
              ),
              FlatButton(
                onPressed: () {
                  Get.to(SignUp());
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
