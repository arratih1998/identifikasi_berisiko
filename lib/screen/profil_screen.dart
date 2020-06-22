import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latihan/main.dart';
import 'package:latihan/models/pengguna.dart';
import 'package:latihan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  SharedPreferences prefs;
  Pengguna _data;
  List _listGender = ["Laki Laki", "Perempuan"];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    prefs = await SharedPreferences.getInstance();
    int kodePengguna = prefs.get("id_pengguna");
    _data = await ApiServices().getPengguna(kodePengguna.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Pengguna"),
        backgroundColor: Colors.brown,
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bg4.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildContent()),
    );
  }

  _buildContent() {
    if (_data == null)
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Memuat data pengguna...",
              style: TextStyle(
                fontSize: 19.0,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      );
    else {
      return Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black45,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100.0,
                  child: Text(
                    "Nama:",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Text(
                  _data.name,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100.0,
                  child: Text(
                    "Jenis Kelamin:",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Text(
                  _listGender[_data.gender],
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100.0,
                  child: Text(
                    "Email:",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Text(
                  _data.email,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(
              height: 14.0,
            ),
            RaisedButton(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15)),
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text("Logout Akun"),
                    content: new Text("Apakah anda yakin ingin logout?"),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: new Text("Ya"),
                      ),
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text("Tidak"),
                      ),
                    ],
                  ),
                );

                if (result ?? false) {
                  await prefs.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                      maintainState: false,
                    ),
                  );
                }
              },
              color: Colors.white70,
              textColor: Colors.white60,
              child: Text(
                "LOGOUT",
                style: TextStyle(
                    letterSpacing: 7.0, fontSize: 17.0, color: Colors.black),
              ),
            )
          ],
        ),
      );
    }
  }
}
