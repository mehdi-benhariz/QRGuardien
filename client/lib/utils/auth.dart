import 'dart:convert';
import 'dart:io';

import 'package:client/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

Future<String> get jwtOrEmpty async {
  var jwt = await storage.read(key: "token");
  if (jwt == null) return "";
  return jwt;
}

Future<String> attemptLogIn(String phone, String password) async {
  print(SERVER_IP);
  String url = "$SERVER_IP/api/v1/worker/signin";
  String jwt = "";

  try {
    var res = await http.post(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8'
      },
      body: {"phone": phone, "password": password},
    );
    print(res.statusCode);
    var user = jsonDecode(res.body)["message"];
    print(user);
    jwt = (res.headers["set-cookie"]!).split(";")[0].substring(6);
    print(jwt);
    if (res.statusCode == 200) return jwt;
  } catch (e) {
    print(e);
  }

  return jwt;
}

Future<String> attemptSignUp(String name, String phone, String password,
    String passwordConfirmation) async {
  String url = "$SERVER_IP/api/v1/worker/signup";
  String jwt = "";
  try {
    var res = await http.post(url, headers: <String, String>{
      'Context-Type': 'application/json;charSet=UTF-8'
    }, body: {
      "name": name,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation
    });
    print(res);
    print(res.statusCode);
    var user = jsonDecode(res.body)["message"];
    print(user);
    jwt = (res.headers["set-cookie"]!).split(";")[0].substring(6);
    print("jwt=" + jwt);
    if (res.statusCode == 200) return jwt;
  } catch (e) {}
  return jwt;
}

void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

bool logout() {
  storage.delete(key: "token");
  return true;
}

Future<bool> workerInfo() async {
  return false;
}

Future<bool> isLogged() async {
  String url = "$SERVER_IP/api/v1/worker/userInfo";
  String jwt = "";

  try {
    var res = await http.get(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8'
      },
    );
    print(res.statusCode);
    var user = jsonDecode(res.body)["message"];
    print(user);
    jwt = (res.headers["set-cookie"]!).split(";")[0].substring(6);
    print(jwt);
    if (res.statusCode == 200) return true;
  } catch (e) {
    print(e);
  }
  return false;
}
