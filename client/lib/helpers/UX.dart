import 'dart:io';

import 'package:client/api/auth.dart';
import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

void handleLogOut(BuildContext context) async {
  if (!await checkInternet()) {
    displayDialog(context, "impossible to log out!",
        "you are not connected, please try to connect ot internet");
    return;
  }
  bool res = await logout();
  if (res)
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  else
    displayDialog(context, "impossible to log out!",
        "it seems there was an error when trying ot log out \n please verify your internet connection and try again");
}

void storeCurrentUser(String name, bool isAdmin, String phone) {
  storage.write(key: "name", value: name);
  storage.write(key: "phone", value: phone);
  storage.write(key: "isAdmin", value: isAdmin.toString());
}

Future<String> get getCurruentUser async {
  String? name = await storage.read(key: "name");

  if (name == null) return "";
  return name;
}
