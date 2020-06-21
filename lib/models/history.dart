import 'dart:convert';

class History {
  final DateTime tanggal;
  final String daftar_gejala;
  final double nilai_cf;
  final String namaanak;
  final String umur;

  History(
      {this.tanggal,
      this.daftar_gejala,
      this.nilai_cf,
      this.namaanak,
      this.umur});

  factory History.fromJson(Map<String, dynamic> map) {
    return History(
      tanggal: DateTime.parse(map["tanggal"]),
      daftar_gejala: map["daftar_gejala"],
      nilai_cf: double.parse(map["nilai_cf"]),
      namaanak: map["namaanak"],
      umur: map["umur"],
    );
  }
}

List<History> historyFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<History>.from(
      data["data"]?.map((item) => History.fromJson(item)) ?? []);
}
