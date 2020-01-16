import 'package:flutter/material.dart';
import 'package:latihan/screen/informasi_screen.dart';
import 'package:latihan/screen/diagnosis_screen.dart';

class HelloMenuScreen extends StatefulWidget {
  @override
  HelloMenuScreenState createState() => HelloMenuScreenState();
}

class HelloMenuScreenState extends State<HelloMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Aplikasi DIA-Risk"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bg8.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        //
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40.0),
            ),
            GridView.count(
              primary: false,
              padding: EdgeInsets.all(5.0),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                //menu 1
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Menu(
                    "Apa Itu Anak Berisiko ?",
                    "assets/icon/icon1.png",
                    tapMenu: () {
                      print("masuk menu apa itu anak berisiko");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InformasiScreen(kode: "1")),
                      );
                    },
                  ),
                ), //menu 2
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Menu(
                    "Ciri anak Berisiko",
                    "assets/icon/icon2.jpg",
                    tapMenu: () {
                      print("masuk menu ciri anak berisiko");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InformasiScreen(kode: "2")),
                      );
                    },
                  ),
                ),
                //menu 3
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Menu(
                    "Faktor penyebab berisiko",
                    "assets/icon/icon3.jpg",
                    tapMenu: () {
                      print("masuk menu faktor penyebab berisiko");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InformasiScreen(
                                  kode: "3",
                                )),
                      );
                    },
                  ),
                ),
                //menu 4
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Menu(
                    "Diagnosis Anak Berisiko",
                    "assets/icon/icon4.jpg",
                    tapMenu: () {
                      print("masuk menu diagnosis anak berisiko");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiagnosisScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  String logoMenu;
  String namaMenu;
  String panggil;
  GestureTapCallback tapMenu;

  Menu(this.namaMenu, this.logoMenu, {this.tapMenu});
  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.black26,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 3.0,
            offset: Offset(5.0, 5.0),
          ),
        ]);
    return Container(
      child: Container(
        constraints: BoxConstraints(),
        padding: EdgeInsets.all(10.0),
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: tapMenu,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Image.asset(
                          logoMenu,
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        namaMenu,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
