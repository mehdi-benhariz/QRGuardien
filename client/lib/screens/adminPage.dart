import 'package:client/models/Shift.dart';
import 'package:client/models/Worker.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<List<Shift>> fetchShifts() async {
    return new List.filled(3, new Shift(new DateTime(2000), 'worker', false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin page '),
      ),
      body: FutureBuilder<List<Shift>>(
          future: fetchShifts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("ok");
              return Center(child: CircularProgressIndicator());
            } else {
              return new ListView.builder(
                itemCount: 30,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new Text("test");
                },
              );
            }
          }),
    );
  }
}
