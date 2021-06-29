import 'package:client/api/shift.dart';
import 'package:client/screens/login.dart';
import 'package:client/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCode = 'Unknown';
  bool submitted = true;
  void handleLogOut() async {
    bool res = await logout();
    if (res)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    else
      displayDialog(context, "impossible to log out!",
          "it seems there was an error when trying ot log out \n please verify your internet connection and try again");
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      print(qrCode);
      // ignore: nullable_type_in_catch_clause
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      this.qrCode = qrCode;
    });
  }

  Future<bool> submitShift() async {
    print("test");
    try {
      bool res = await attempSubmitShift();
      setState(() => submitted = res);
      if (!res)
        displayDialog(context, "error", "can't store or scan the code!");
    } catch (e) {
      print(e);
    }

    return true;
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
              accountName: Text('User Name'),
              accountEmail: Text('examlpe@gmail.com'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              title: Text("Profile Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              title: Text("Settings"),
              onTap: () {},
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
              onTap: handleLogOut,
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
        title: Text("Home Page"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6bceff),
        onPressed: scanQRCode,
        child: Icon(Icons.camera_alt_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xff6bceff),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
            padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
            width: 420.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: submitted
                ? ElevatedButton(
                    child: Text(
                      "Submit Shift",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => submitShift(),
                  )
                : Center(
                    child: Text(
                      "please tap the camera button to scan the code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(105, 210, 245, 0.6),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
