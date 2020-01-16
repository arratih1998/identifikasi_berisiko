import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latihan/menu.dart';
import 'package:latihan/screen/informasi_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Latihan",
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreenContainer();
  }
}

class HomeScreenContainer extends StatefulWidget {
  @override
  _HomeScreenContainerState createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends State<HomeScreenContainer> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text("Confirm Action!"),
            content: new Text("Apakah anda yakin?"),
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
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Aplikasi DIA-Risk"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bg8.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Welcome to Aplikasi Diagnosis Anak Berisiko (DIA-Risk)",
                  style: TextStyle(
                    height: 1.0,
                    fontSize: 40.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              Text(
                "(anak adalah titipan Tuhan yang paling berharga. Jagalah...)",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: MainMenu(
                  "M E N U ",
                  tapMenu: () {
                    print("masuk ke Menu");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelloMenuScreen()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: MainMenu(
                  "A B O U T  A P P S",
                  tapMenu: () {
                    print("masuk ke about");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformasiScreen(
                                kode: "4",
                              )),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: MainMenu(
                  "K E L U A R",
                  tapMenu: () {
                    return showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15)),
                            backgroundColor: Colors.white,
                            title: Text("Confirm Action"),
                            content: Text("Apakah anda yakin ?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Ya"),
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Tidak"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  String namaMenu;
  GestureTapCallback tapMenu;

  MainMenu(this.namaMenu, {this.tapMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: tapMenu,
              child: Row(
                children: <Widget>[
                  Text(
                    namaMenu,
                    style: TextStyle(color: Colors.white70, fontSize: 15.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.all(25.0),
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blueGrey,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            offset: Offset(
              5.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          ),
        ],
      ),
    );
  }
}
