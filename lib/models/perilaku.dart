import 'dart:convert';

class Perilaku {
  String kode;
  String perilaku;
  double md, mb;

  Perilaku({this.kode, this.perilaku, this.mb, this.md});

  factory Perilaku.fromJson(Map<String, dynamic> map) {
    return Perilaku(
        kode: map["kode_perilaku"],
        perilaku: map["perilaku"],
        mb: map["mb"],
        md: map["md"]);
  }
}

List<Perilaku> perilakuFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Perilaku>.from(
      data["data"].map((item) => Perilaku.fromJson(item)));
}
