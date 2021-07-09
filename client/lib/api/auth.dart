import 'dart:convert';
//import 'package:dio/dio.dart';

import 'package:client/config/config.dart';
import 'package:client/models/Worker.dart';
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

Future<bool> get getIsAdmin async {
  String? isAdminS = await storage.read(key: "isAdmin");
  bool isAdmin = isAdminS!.toLowerCase() == 'true';
  return isAdmin;
}

Future<Worker> get curruentUser async {
  String? name = await storage.read(key: "name");
  String? phone = await storage.read(key: "phone");
  bool isAdmin = await getIsAdmin;
  return new Worker(name!, phone!, "password", isAdmin);
}

Future<String> attemptLogIn(String phone, String password) async {
  String url = "$SERVER_IP/api/v1/worker/signin";
  String jwt = "";
  //just for testing
  phone = "00000000";
  password = "testtest";
  try {
    var res = await http.post(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8'
      },
      body: {"phone": phone, "password": password},
    );
    var user = Worker.fromJson(jsonDecode(res.body)["message"]);
    storage.write(key: "isAdmin", value: user.isAdmin.toString());

    print(user.toString());
    print(user.toJson());

    jwt = (res.headers["set-cookie"]!).split(";")[0].substring(6);
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
    print("login");
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
    //TODO: add user model and store it in local storage
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

Future<bool> logout() async {
  String url = "$SERVER_IP/api/v1/worker/logOut";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print(jwt);
  try {
    var res = await http.post(
      url,
      headers: {"cookies": "token=" + jwt},
    );
    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 200) {
      print(res.body);
      storage.delete(key: "token");
      return true;
    }
  } catch (e) {
    print(e);
  }
  return false;
}

//to check if logged and admin
Future<Map<String, bool>> workerInfo() async {
  String url = "$SERVER_IP/api/v1/worker/userInfo";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print(jwt);
  try {
    var res = await http.get(
      url,
      headers: {"cookies": "token=" + jwt},
    );
    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 200) {
      print(res.body);
//      return res.body;
    }
  } catch (e) {
    print(e);
  }
  return {"isAdmin": false, "isLogged": false};
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
