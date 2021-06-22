import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();
const SERVER_IP = 'http://localhost:5000';

Future<String> get jwtOrEmpty async {
  var jwt = await storage.read(key: "token");
  if (jwt == null) return "";
  return jwt;
}

Future<String> attemptLogIn(String phone, String password) async {
  var res = await http.post(Uri.parse("http://127.0.0.1/api/v1/worker/signin"),
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8'
      },
      body: jsonEncode(<String, String>{"phone": phone, "password": password}));
  print(res.statusCode);
  if (res.statusCode == 200) return res.body;
  return "";
}

Future<int> attemptSignUp(String name, String phone, String password,
    String passwordConfirmation) async {
  var res = await http.post('$SERVER_IP/api/v1/worker/signup', body: {
    "username": name,
    "phone": phone,
    "password": password,
    "password_confirmation": passwordConfirmation
  });
  return res.statusCode;
}

void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

Future<bool> logout() async {
  var res = await http.post("$SERVER_IP/api/v1/worker/logout");
  if (res == "logged Out") return true;
  return false;
}
