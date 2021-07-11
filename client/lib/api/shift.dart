import 'dart:convert';

import 'package:client/api/auth.dart';
import 'package:client/config/config.dart';
import 'package:client/models/Shift.dart';
import 'package:client/models/Worker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

Future<bool> attempSubmitShift() async {
  String url = "$SERVER_IP/api/v1/shift/submitShift";
  String jwt = "";
  jwt = await jwtOrEmpty;
  print("shift" + jwt);
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

Future<List<Shift>> allShifts() async {
  String url = "$SERVER_IP/api/v1/shift/all";
  String jwt = "";
  jwt = await jwtOrEmpty;
  List<Shift> shifts = [];

  try {
    var res = await http.post(
      url,
      headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        "cookies": "token=" + jwt,
      },
    );
    print(res.statusCode);

    // if (res.statusCode == 200) print(jsonDecode(res.body));
    var body = jsonDecode(res.body);
    for (var i = 0; i < body.length; i++) {
      Worker newWorker = new Worker(body[i]["worker"]["name"],
          body[i]["worker"]["phone"], "password", false);

      DateTime date = DateTime.parse(body[i]["date"]);
      bool done = body[i]["done"];
      Shift newShift = new Shift(date, newWorker, done);
      shifts.add(newShift);
    }
  } catch (e) {
    print(e);
  }
  return shifts;
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
