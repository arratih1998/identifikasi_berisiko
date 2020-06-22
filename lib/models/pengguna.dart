class Pengguna {
  String name;
  int gender;
  String email;
  String password;

  Pengguna({this.name, this.gender, this.email, this.password});

  factory Pengguna.fromJson(Map<String, dynamic> map) {
    return Pengguna(
      name: map["name"],
      gender: int.parse(map["gender"]),
      email: map["email"],
      password: map["password"],
    );
  }
}
