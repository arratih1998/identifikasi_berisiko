import 'package:http/http.dart';
import 'package:latihan/models/informasi.dart';
import 'package:latihan/models/perilaku.dart';

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

  Future<List<Perilaku>> getPerilaku() async {
    final response = await client.get("$baseUrl/get_perilaku.php");
    if (response.statusCode == 200) {
      return perilakuFromJson(response.body);
    } else {
      return null;
    }
  }
}
