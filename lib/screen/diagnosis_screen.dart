import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan/models/history.dart';
import 'package:latihan/models/penanganan.dart';
import 'package:latihan/models/perilaku.dart';
import 'package:latihan/services/api_service.dart';
import 'package:latihan/sistem_pakar/identifikasi.dart';
import 'package:latihan/utils/dialog.dart';
import 'package:latihan/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_text/styled_text.dart';

import '../sistem_pakar/identifikasi.dart';

class DiagnosisScreen extends StatefulWidget {
  final History history;

  const DiagnosisScreen({Key key, this.history}) : super(key: key);

  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class RadioGroup {
  final int index;
  final String text;

  RadioGroup({this.index, this.text});
}

enum ViewState {
  initialize,
  welcome,
  pertanyaan,
  review,
  hasilProses,
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _formInit = GlobalKey<FormState>();
  final _focusNode = FocusScopeNode();
  String _name;
  String _age;
  List<Perilaku> _data;
  Penanganan _penanganan;
  int index = 0;
  int no = 0;
  bool terpilih = false;
  Map<int, int> jawaban = new Map();
  Identifikasi perhitungan;

  ViewState state = ViewState.welcome;

  int indexTerpilih = -1;

  List _listAge = ["2 - 3 tahun", "4 - 5 tahun"];

  @override
  Future initState() {
    if (widget.history != null) {
      state = ViewState.hasilProses;
      _name = widget.history.namaanak;
      _getHistoryData();
    }

    super.initState();
  }

  Future<void> _getHistoryData() async {
    int bagian =
        _listAge.indexWhere((element) => element == widget.history.umur);
    List<String> kodeGejala = widget.history.daftar_gejala.split(",");
    await ambilData(bagian);

    kodeGejala.forEach((element) {
      jawaban[int.parse(element)] = 1;
    });

    await _getPenanganan(bagian, determineLevel(kodeGejala.length).level,
        getTingkatanResikoFromCF(widget.history.nilai_cf).level);
  }

  Future _getPenanganan(int bagian, int levelRisiko, int levelKepercayaan,
      {String daftarGejala,
      double nilaiCF,
      String namaAnak,
      String umur}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int kodePengguna = prefs.get("id_pengguna");
    _penanganan = await ApiServices().getPenangananAddHistory(
        bagian, levelRisiko, levelKepercayaan,
        kodePengguna: kodePengguna,
        daftarGejala: daftarGejala,
        nilaiCF: nilaiCF,
        namaAnak: namaAnak,
        umur: umur);
    setState(() {});
  }

  Future ambilData(int bagian) async {
    await Future.delayed(Duration(seconds: 1));
    _data = await ApiServices().getPerilaku(bagian);
    setState(() {});
  }

  final List<RadioGroup> _levelList = [
    RadioGroup(index: 0, text: "Tidak, dia (anak) tidak mengalaminya"), // 0
    RadioGroup(index: 1, text: "Iya, dia (anak) mengalami hal tersebut"), // 1
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
                      // DONT FORGET
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
          "Selamat datang di halaman Diagnosis ASD",
          style: TextStyle(
            fontSize: 19.0,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        SizedBox(
          height: 18.0,
        ),
        FocusScope(
          node: _focusNode,
          child: Form(
            key: _formInit,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 80.0,
                      child: Text(
                        "Nama Anak: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Flexible(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: Validator.noEmptyValidator,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (d) => _name = d,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Nama",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.brown),
                          ),
                          focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 80.0,
                      child: Text(
                        "Umur Anak:\t ",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        padding: EdgeInsets.only(top: 8.0),
                        height: 64.0,
                        child: DropdownButton(
                          hint: Text(
                            "Pilih Rentang Umur",
                            style: TextStyle(color: Colors.white54),
                          ),
                          value: _age,
                          onTap: () => _focusNode.unfocus(),
                          dropdownColor: Colors.brown,
                          items: _listAge.map((value) {
                            return DropdownMenuItem(
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _age = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              if (_age == null) {
                MessageDialog("Diagnosis ASD",
                        "Rentang umur harus diisi terlebih dahulu", context)
                    .Show();
                return;
              }

              if (_formInit.currentState.validate()) {
                ambilData(_listAge.indexWhere((element) => element == _age));
                setState(() {
                  state = ViewState.pertanyaan;
                });
              }
            },
            color: Colors.white70,
            textColor: Colors.white60,
            child: Text(
              "Mulai",
              style: TextStyle(letterSpacing: 7.0, fontSize: 17.0),
            ),
          ),
        )
      ];
    } else if (state == ViewState.welcome) {
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
      if (_data == null)
        return <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Menentukan gejala untuk umur $_age...",
                    style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
          )
        ];

      return <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_data[no].kode + ".",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white70,
                )),
            SizedBox(
              width: 5.0,
            ),
            Flexible(
              child: Text(_data[index].pertanyaan,
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
                if (index + 1 < _data.length) {
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
        if (jawaban == 0) return; // jika jawaban 0 tidak ditambahkan
        hasilPilih.add(Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_data[index].kode + ". ",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
                Flexible(
                  child: Text(_data[index].pertanyaan,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _levelList[jawaban].text,
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
              onPressed: () {
                List<Perilaku> tempData = [];

                jawaban.forEach((index, jawaban) {
                  // jika jawaban IYA
                  if (jawaban == 1) {
                    tempData.add(_data[index]);
                  }
                });

                perhitungan = new Identifikasi(tempData);
                perhitungan.hitungMB();
                perhitungan.hitungMD();
                perhitungan.hitungCF();
                TingkatanKepercayaan hasil = perhitungan.ambilHasil();
                final answer =
                    jawaban.entries.where((element) => element.value == 1);
                _getPenanganan(
                    _listAge.indexWhere((element) => element == _age),
                    determineLevel(answer.length).level,
                    hasil.level,
                    daftarGejala: answer.map((e) => e.key).toList().join(","),
                    nilaiCF: perhitungan.nilaiCF,
                    namaAnak: _name,
                    umur: _age);
                setState(() {
                  state = ViewState.hasilProses;
                });
              },
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
      if (_penanganan == null)
        return <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    widget.history != null
                        ? "Memuat data..."
                        : "Menentukan penanganan...",
                    style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
          )
        ];

      final answer = jawaban.entries.where((element) => element.value == 1);
      int number = 0;

      return <Widget>[
        Text(
          "HASIL DIAGNOSIS",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          "$_name mengalami gejala:",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(
          height: 12.0,
        ),
        Column(
          children: answer.map((d) {
            number++;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(number.toString() + ". ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                  Flexible(
                    child: Text(_data[d.key].gejala,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 12.0,
        ),
        StyledText(
          text: 'Berdasarkan gejala tersebut, risiko yang dialami adalah <bold>'
              '${determineLevel(answer.length).nama}</bold>. Dengan nilai '
              'kepercayaan <bold>${widget.history == null ? perhitungan.nilaiCF.toString() : widget.history.nilai_cf.toString()}</bold>',
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontStyle: FontStyle.italic),
          styles: {
            'bold': TextStyle(fontWeight: FontWeight.bold),
          },
        ),
        SizedBox(
          height: 18.0,
        ),
        Text(
          "Beberapa solusi yang dapat dilakukan di rumah:",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 18.0,
        ),
        Text(
          _penanganan.isi,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
          textAlign: TextAlign.left,
        ),
        RaisedButton(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          color: Colors.white70,
          textColor: Colors.white60,
          child: Text(
            "SELESAI",
            style: TextStyle(letterSpacing: 7.0, fontSize: 17.0),
          ),
        ),
      ];
    }
  }

  Future<bool> _onWillPop() async {
    if (widget.history != null) return true;

    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah Anda yakin?'),
            content: new Text('Jika keluar, maka proses identifikasi selesai'),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Diagnosis ASD"),
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
            child: ListView(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                physics: BouncingScrollPhysics(),
                children: determineView()),
          ),
        ),
      ),
    );
  }

  TingkatanRisiko determineLevel(int length) {
    TingkatanRisiko result;
    if (length >= 9)
      result = TingkatanRisiko("Risiko Tinggi", 3);
    else if (length >= 4)
      result = TingkatanRisiko("Risiko Sedang", 2);
    else if (length >= 1) result = TingkatanRisiko("Risiko Rendah", 1);

    return result;
  }
}
