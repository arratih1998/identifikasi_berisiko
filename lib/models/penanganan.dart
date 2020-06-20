import 'dart:convert';

class Penanganan {
  String kode;
  String isi;
  String bagian;

  Penanganan({this.kode, this.isi, this.bagian});

  factory Penanganan.fromJson(Map<String, dynamic> map) {
    return Penanganan(
        kode: map["kode_penanganan"], isi: map["isi"], bagian: map["bagian"]);
  }
}

List<Penanganan> penangananFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Penanganan>.from(
      data["data"].map((item) => Penanganan.fromJson(item)));
}
