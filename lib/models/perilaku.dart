import 'dart:convert';

class Perilaku {
  String kode;
  String pertanyaan;
  String gejala;
  String md, mb;

  double getMD() {
    return double.parse(md);
  }

  double getMB() {
    return double.parse(mb);
  }

  Perilaku({this.kode, this.pertanyaan, this.gejala, this.mb, this.md});

  factory Perilaku.fromJson(Map<String, dynamic> map) {
    return Perilaku(
        kode: map["kode_gejala"],
        pertanyaan: map["pertanyaan"],
        gejala: map["gejala"],
        mb: map["mb"],
        md: map["md"]);
  }
}

List<Perilaku> perilakuFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Perilaku>.from(
      data["data"].map((item) => Perilaku.fromJson(item)));
}
