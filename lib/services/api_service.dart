import 'dart:convert';

import 'package:http/http.dart';
import 'package:latihan/models/history.dart';
import 'package:latihan/models/informasi.dart';
import 'package:latihan/models/penanganan.dart';
import 'package:latihan/models/pengguna.dart';
import 'package:latihan/models/perilaku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final String baseUrl = "http://api.aziz-nur.id/diagnosisberisiko/php";
  Client client = Client();

  Future<Informasi> getInformasi(String kode) async {
    final response =
        await client.get("$baseUrl/get_information.php?kode=$kode");
    if (response.statusCode == 200) {
      return informasiFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Pengguna> getPengguna(String kode) async {
    final response = await client.get("$baseUrl/get_pengguna.php?kode=$kode");
    if (response.statusCode == 200) {
      return Pengguna.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Perilaku>> getPerilaku(int bagian) async {
    final response =
        await client.get("$baseUrl/get_perilaku.php?bagian=$bagian");
    if (response.statusCode == 200) {
      return perilakuFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<History>> getHistory(int kodePengguna) async {
    final response = await client
        .get("$baseUrl/get_history.php?kode_pengguna=$kodePengguna");
    if (response.statusCode == 200) {
      return historyFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Penanganan> getPenangananAddHistory(
      int bagian, int levelRisiko, int levelKepercayaan,
      {int kodePengguna,
      String daftarGejala,
      double nilaiCF,
      String namaAnak,
      String umur}) async {
    String tambah = "";
    if (daftarGejala != null)
      tambah = "&kode_pengguna=$kodePengguna"
          "&daftar_gejala=$daftarGejala&nilai_cf=$nilaiCF&namaanak="
          "$namaAnak&umur=$umur";

    final response = await client
        .get("$baseUrl/get_penanganan.php?bagian=${bagian + 1}&level_risiko="
                "$levelRisiko&level_kepercayaan=$levelKepercayaan" +
            tambah);
    if (response.statusCode == 200) {
      return Penanganan.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    var data = {
      "email": email,
      "password": password,
    };
    final response = await client.post("$baseUrl/login_user.php", body: data);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'id_pengguna',
        int.tryParse(json.decode(response.body)["id_pengguna"]),
      );
      await prefs.setString(
        'name',
        json.decode(response.body)["name"],
      );
      return true;
    } else
      return false;
  }

  Future<bool> registerUser(
      String name, int gender, String email, String password) async {
    var data = {
      "name": name,
      "gender": gender.toString(),
      "email": email,
      "password": password,
    };
    final response =
        await client.post("$baseUrl/register_user.php", body: data);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
