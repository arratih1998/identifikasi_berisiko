import 'dart:convert';

class Perilaku {
  String kode;
  String perilaku;

  Perilaku({this.kode, this.perilaku});

  factory Perilaku.fromJson(Map<String, dynamic> map) {
    return Perilaku(kode: map["kode_perilaku"], perilaku: map["perilaku"]);
  }
  Map<String, dynamic> toJson() {
    return {"kode_perilaku": kode, "perilaku": perilaku};
  }
}

List<Perilaku> perilakuFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Perilaku>.from(
      data["data"].map((item) => Perilaku.fromJson(item)));
}
