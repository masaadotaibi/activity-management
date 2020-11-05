import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controllers/bindings/auth_binding.dart';
import './screens/login.dart';
import './utils/root.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // 7 this binding to make the auth service available throughout the app
      initialBinding: AuthBinding(),
      home: Root(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.red[900],
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
          backgroundColor: Colors.red[600],
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          color: Color(0xFFd52800),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}
