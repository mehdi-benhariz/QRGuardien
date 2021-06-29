import 'package:client/screens/adminPage.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/signup.dart';
//import 'package:client/api/auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/adminPage': (context) => AdminPage(),
      },
    );
  }
}
