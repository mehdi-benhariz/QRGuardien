import 'package:client/api/auth.dart';
import 'package:client/api/shift.dart';
import 'package:client/helpers/UX.dart';
import 'package:client/helpers/WorkerCard.dart';
import 'package:client/models/Shift.dart';
import 'package:client/models/Worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Worker _user;
  void getInfo() async {
    curruentUser.then((value) => setState(() => this._user = value));
  }

  Future<List<Shift>> fetchShifts() async {
    List<Shift> shifts = await allShifts();
    print(shifts[0].done);
    return shifts;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    this.getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50.0,
                ),
              ),
              accountName: Text(_user.name),
              accountEmail: Text(_user.phone),
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              title: Text("About us"),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.cached,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              title: Text("Recenceter"),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              onTap: () => handleLogOut(this.context),
              leading: CircleAvatar(
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Admin page '),
      ),
      body: FutureBuilder<List<Shift>>(
          future: fetchShifts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return new ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return WorkerCard(shift: snapshot.data[index]);
                },
              );
            } else {
              print("ok");
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
