import 'dart:convert';
//import 'package:dio/dio.dart';

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
  String url = "$SERVER_IP/api/v1/worker/signin";
  String jwt = "";
  //just for testing
  phone = "11111111";
  password = "testtest";
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

/* class ApiProvider {
  Dio _dio;
  String aToken = '';

  final BaseOptions options = new BaseOptions(
    baseUrl: 'http://3.8.141.177:6001/gateway',
    connectTimeout: 15000,
    receiveTimeout: 13000,
  );
  static final ApiProvider _instance = ApiProvider._internal();

  factory ApiProvider() => _instance;

  ApiProvider._internal() {
    _dio = Dio(options);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      // to prevent other request enter this interceptor.
      _dio.interceptors.requestLock.lock();
      // We use a new Dio(to avoid dead lock) instance to request token.
      //Set the cookie to headers
      options.headers["cookie"] = aToken;

      _dio.interceptors.requestLock.unlock();
      return options; //continue
    }));
  }

  Future login() async {
    final request = {
      "userName": "Chinmay@gmail.com",
      "password": "123456",
      "token": "123456"
    };
    final response = await _dio.post('/user/login', data: request);
    //get cooking from response
    final cookies = response.headers.map['set-cookie'];
    if (cookies.isNotEmpty && cookies.length == 2) {
      final authToken = cookies[1]
          .split(';')[0]; //it depends on how your server sending cookie
      //save this authToken in local storage, and pass in further api calls.

      aToken =
          authToken; //saving this to global variable to refresh current api calls to add cookie.
      print(authToken);
    }

    print(cookies);
    //print(response.headers.toString());
  }

  /// If we call this function without cookie then it will throw 500 err.
  Future getRestaurants() async {
    final response = await _dio.post('/restaurant/all');

    print(response.data.toString());
  }
}
 */
