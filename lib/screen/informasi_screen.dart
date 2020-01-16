import 'package:flutter/material.dart';
import 'package:latihan/models/informasi.dart';
import 'package:latihan/services/api_service.dart';

class InformasiScreen extends StatefulWidget {
  final String kode;

  const InformasiScreen({Key key, this.kode}) : super(key: key);

  @override
  _InformasiScreenState createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  Informasi data;

  @override
  Future initState() {
    ambilData();
    super.initState();
  }

  Future ambilData() async {
    data = await ApiServices().getInformasi(widget.kode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (data == null)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text(data.judul),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bg4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          constraints: BoxConstraints.expand(),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.black45,
          ),
          child: ListView(
            children: <Widget>[
              Text(data.judul,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 10.0,
              ),
              Image.network(data.gambar),
              SizedBox(
                height: 10.0,
              ),
              Text(
                data.isi,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.ltr,
              )
            ],
          ),
        ),
      ),
    );
  }
}
