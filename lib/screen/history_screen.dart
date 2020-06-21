import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latihan/models/history.dart';
import 'package:latihan/screen/diagnosis_screen.dart';
import 'package:latihan/services/api_service.dart';
import 'package:latihan/utils/formater.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> _data;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Diagnosis ASD"),
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

  Widget _buildContent() {
    int index = 0;
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
              "Mengambil history diagnosis...",
              style: TextStyle(
                fontSize: 19.0,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      );
    else if (_data.isEmpty)
      return Center(
        child: Text(
          "Kamu belum pernah menjalankan diagnosis sebelumnya.",
          style: TextStyle(fontSize: 25.0),
          textAlign: TextAlign.center,
        ),
      );

    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.black45,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 8.0),
          children: _data.map((e) {
            index++;
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiagnosisScreen(
                          history: e,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                          child: Text(
                            index.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "Nama Anak:",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                ),
                                Text(
                                  e.namaanak,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "Umur:",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                ),
                                Text(
                                  e.umur,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "Tanggal:",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                ),
                                Text(
                                  formatDate(e.tanggal),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.white,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _getData() async {
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int kodePengguna = prefs.get("id_pengguna");
    _data = await ApiServices().getHistory(kodePengguna);
    setState(() {});
  }
}
