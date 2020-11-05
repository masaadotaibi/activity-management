import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../screens/login.dart';
import '../utils/root.dart';

class SignUp extends GetWidget<AuthController> {
  final _emailController = TextEditingController(); // ?
  final _nameController = TextEditingController(); // ?
  final _passwordController = TextEditingController(); // ?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
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
                  controller.createUser(_emailController.text,
                      _nameController.text, _passwordController.text);
                },
                child: Text('Sign Up'),
              ),
              FlatButton(
                onPressed: () {
                  Get.to(Login());
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
