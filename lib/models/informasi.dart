import 'dart:convert';

class Informasi {
  String kode;
  String judul;
  String isi;
  String gambar;

  Informasi({this.kode, this.judul, this.isi, this.gambar});

  factory Informasi.fromJson(Map<String, dynamic> map) {
    return Informasi(
        kode: map["kode"],
        judul: map["judul"],
        isi: map["isi"],
        gambar: map["gambar"]);
  }
  Map<String, dynamic> toJson() {
    return {"kode": kode, "judul": judul, "isi": isi, "gambar": gambar};
  }
}

Informasi informasiFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return Informasi.fromJson(data["data"]);
}
