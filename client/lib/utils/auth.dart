import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();
const SERVER_IP = 'http://localhost:5000/';

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "token");
    if(jwt == null) return "";
    return jwt;
  }
  Future<String?> attemptLogIn(String phone, String password) async {
  var res = await http.post(
    "$SERVER_IP/api/v1/worker/signin",
    body: {
      "phone": phone,
      "password": password
    }
  );
  if(res.statusCode == 200) return res.body;
  return null;
}
Future<int> attemptSignUp(String name,String phone,String password,String passwordConfirmation) async {
  var res = await http.post(
    '$SERVER_IP/signup',
    body: {
      "username": name,
      "phone":phone,
      "password": password,
      "password_confirmation":passwordConfirmation
    }
  );
  return res.statusCode;  
}