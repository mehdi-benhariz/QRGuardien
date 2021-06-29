import 'package:client/api/auth.dart';
import 'package:client/config/config.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

Future<bool> attempSubmitShift() async {
  String url = "$SERVER_IP/api/v1/worker/submitShift";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print("shift");
  try {
    var res = await http.post(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        "cookies": "token=" + jwt,
      },
    );
    print(res.statusCode);

    if (res.statusCode == 200) return true;
  } catch (e) {
    print(e);
  }

  return false;
}

Future<bool> allShifts() async {
  String url = "$SERVER_IP/api/v1/shift/all";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print("shift");
  try {
    var res = await http.post(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        "cookies": "token=" + jwt,
      },
    );
    print(res.statusCode);

    if (res.statusCode == 200) return true;
  } catch (e) {
    print(e);
  }

  return false;
}

Future<bool> removeShift(String id) async {
  String url = "$SERVER_IP/api/v1/shift/remove/$id";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print("shift");
  try {
    var res = await http.delete(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        "cookies": "token=" + jwt,
      },
    );
    print(res.statusCode);

    if (res.statusCode == 200) return true;
  } catch (e) {
    print(e);
  }

  return false;
}

Future<bool> editShift(String id) async {
  String url = "$SERVER_IP/api/v1/shift/edit/$id";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print("shift");
  try {
    var res = await http.put(url, headers: <String, String>{
      'Context-Type': 'application/json;charSet=UTF-8',
      "cookies": "token=" + jwt,
    }, body: {});
    print(res.statusCode);

    if (res.statusCode == 200) return true;
  } catch (e) {
    print(e);
  }

  return false;
}
