import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan/models/perilaku.dart';
import 'package:latihan/services/api_service.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class RadioGroup {
  final int index;
  final String text;
  RadioGroup({this.index, this.text});
}

enum ViewState {
  welcome,
  pertanyaan,
  review,
  hasilProses,
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  List<Perilaku> data;
  int index = 0;
  int no = 0;
  bool terpilih = false;
  Map<int, int> jawaban = new Map();

  ViewState state = ViewState.welcome;

  int indexTerpilih = -1;

  @override
  Future initState() {
    ambilData();
    super.initState();
  }

  Future ambilData() async {
    data = await ApiServices().getPerilaku();
    setState(() {});
  }

  final List<RadioGroup> _levelList = [
    RadioGroup(index: 1, text: "Iya, dia (anak) mengalami hal tersebut"), // 0
    RadioGroup(index: 2, text: "Tidak, dia (anak) tidak mengalaminya"), // 1
  ];

  Widget _buildRadioButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _levelList
          .map((level) => Row(
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                        unselectedWidgetColor: Colors.white.withOpacity(0.5)),
                    child: Radio(
                      activeColor: Colors.white,
                      value: level.index,
                      groupValue: indexTerpilih,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() {
                          terpilih = true;
                          indexTerpilih = value;
                          jawaban[index] = value;
                        });
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        terpilih = true;
                        indexTerpilih = level.index;
                        jawaban[index] = level.index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        level.text,
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }

  List<Widget> determineView() {
    if (state == ViewState.welcome) {
      return <Widget>[
        Text(
          "Selamat Datang di Menu Identifikasi Anak berisiko, terdapat 20 perilaku dan 5 pilihan level. Baca dan teliti dalam melakukan identifikasi ini. Dalam identifikasi ini, terdapat beberapa perilaku anak di lingkungan sekolah pastikan Anda sebagai orang tua/wali sudah berkomunikasi dengan guru, begitu juga sebaliknya.",
          style: TextStyle(
            fontSize: 19.0,
            color: Colors.white70,
          ),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.ltr,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Tekan tombol Identifikasi untuk melajutkan.",
          style: TextStyle(
            fontSize: 19.0,
            color: Colors.white70,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        SizedBox(
          height: 50.0,
          child: RaisedButton(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            onPressed: () {
              setState(() {
                state = ViewState.pertanyaan;
              });
            },
            color: Colors.white70,
            textColor: Colors.white60,
            child: Text(
              "IDENTIFIKASI",
              style: TextStyle(letterSpacing: 7.0, fontSize: 17.0),
            ),
          ),
        )
      ];
    } else if (state == ViewState.pertanyaan) {
      return <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data[no].kode + ".",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white70,
                )),
            SizedBox(
              width: 5.0,
            ),
            Flexible(
              child: Text(data[index].perilaku,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                  )),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        _buildRadioButton(),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: RaisedButton(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10)),
            onPressed: () {
              if (terpilih == true) {
                if (index + 1 < data.length) {
                  print("############ jawaban " + "${[jawaban]}");
                  setState(() {
                    no++;
                    index++;
                    terpilih = false;
                    indexTerpilih = -1;
                  });
                } else {
                  setState(() {
                    state = ViewState.review;
                  });
                }
              } else {
                // https://pub.dev/packages/fluttertoast#-readme-tab-

                Fluttertoast.showToast(
                    msg:
                        "Anda belum memilih level, pilihlah untuk melanjutkan proses identifikasi",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            color: Colors.white70,
            textColor: Colors.white70,
            child: Text(
              "Lanjut",
              style: TextStyle(letterSpacing: 5.0, fontSize: 15.0),
            ),
          ),
        ),
      ];
    } else if (state == ViewState.review) {
      List<Widget> hasilPilih = [];

      jawaban.forEach((index, jawaban) {
        hasilPilih.add(Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(data[index].kode + ". ",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
                Flexible(
                  child: Text(data[index].perilaku,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _levelList[jawaban - 1].text,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
      });

      return <Widget>[
        Text(
          "REVIEW PERTANYAAN IDENTIFIKASI",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(
          height: 7.0,
        ),
        Text(
          "Ini adalah pertanyaan dan jawaban yang anda pilih",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(
          height: 10.0,
        ),
      ]
        ..addAll(hasilPilih)
        ..addAll([
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Tekan tombol 'Proses Hasil' untuk mengetahui hasil identifikasi",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10)),
              onPressed: () {},
              color: Colors.white70,
              textColor: Colors.white70,
              child: Text(
                "PROSES HASIL",
                style: TextStyle(letterSpacing: 7.0, fontSize: 20.0),
              ),
            ),
          ),
        ]);
    } else {
      return <Widget>[];
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah Anda yakin?'),
            content: new Text(
                'Jika keluar, maka proses identifikasi selesai, tanpa menyimpan!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Ya'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Tidak'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (data == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Identifikasi Anak Berisiko"),
          backgroundColor: Colors.brown,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bg2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black54,
            ),
            child: ListView(children: determineView()),
          ),
        ),
      ),
    );
  }
}
