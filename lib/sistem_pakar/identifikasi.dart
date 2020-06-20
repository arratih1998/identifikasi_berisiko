import 'package:flutter/material.dart';

import '../models/perilaku.dart';

class Tingkatan {
  String nama;
  RangeValues range;

  Tingkatan(this.nama, this.range);
}

class Identifikasi {
  List<Perilaku> listPerilaku;
  double nilaiMB;
  double nilaiMD;
  double nilaiCF;
  List<Tingkatan> tingkatan;

  Identifikasi(this.listPerilaku) {
    tingkatan = <Tingkatan>[
      Tingkatan(
          "Sangat Tinggi untuk berisiko, sayangi DIA lebih dari biasanya, jika perlu bawa DIA ke psikiater ",
          RangeValues(0.8, 1.0)),
      Tingkatan("Tinggi untuk berisiko, sayangi DIA lebih dari biasanya, ",
          RangeValues(0.6, 0.79)),
      Tingkatan(
          "Sedang untuk berisiko, namun kemungkinan untuk DIA sedikit lagi berisiko",
          RangeValues(0.4, 0.59)),
      Tingkatan("Rendah untuk berisiko, namun tetap sayangi dan support DIA",
          RangeValues(0.2, 0.39)),
      Tingkatan(
          "Sangat Rendah untuk berisiko, namun tetap sayangi DIA ya. Selalu. ",
          RangeValues(0.0, 0.19)),
    ];

    listPerilaku.map((d) {
      print("######Identifikasi.Identifikasi MB MD ${[d.getMB(), d.getMD()]} ");
    }).toList();
  }

  void hitungMB() {
    double nilaiMBAkhir;
    int index = 0;
    listPerilaku.forEach((d) {
      if (index == 0) {
        print("######Identifikasi hitung MB ${[
          listPerilaku[index].getMB(),
          listPerilaku[index + 1].getMB(),
          listPerilaku[index].getMB()
        ]} ");
        nilaiMBAkhir = listPerilaku[index].getMB() +
            listPerilaku[index + 1].getMB() * (1 - listPerilaku[index].getMB());
        print("######Identifikasi  hasil MB ${[nilaiMBAkhir, index]} ");
      } else if (index < listPerilaku.length - 1) {
        print("######Identifikasi hitung MB ${[
          nilaiMBAkhir,
          listPerilaku[index + 1].getMB(),
          nilaiMBAkhir
        ]} ");
        nilaiMBAkhir =
            nilaiMBAkhir + listPerilaku[index + 1].getMB() * (1 - nilaiMBAkhir);
        print("######Identifikasi  hasil MB ${[nilaiMBAkhir, index]} ");
      }
      index++;
    });
    nilaiMB = nilaiMBAkhir;
  }

  void hitungMD() {
    double nilaiMDAkhir;
    int index = 0;
    listPerilaku.forEach((d) {
      if (index == 0) {
        print("######Identifikasi hitung MD ${[
          listPerilaku[index].getMD(),
          listPerilaku[index + 1].getMD(),
          listPerilaku[index].getMD()
        ]} ");
        nilaiMDAkhir = listPerilaku[index].getMD() +
            listPerilaku[index + 1].getMD() * (1 - listPerilaku[index].getMD());
        print("######Identifikasi  hasil MD ${[nilaiMDAkhir, index]} ");
      } else if (index < listPerilaku.length - 1) {
        print("######Identifikasi hitung MD ${[
          nilaiMDAkhir,
          listPerilaku[index + 1].getMD(),
          nilaiMDAkhir
        ]} ");
        nilaiMDAkhir =
            nilaiMDAkhir + listPerilaku[index + 1].getMD() * (1 - nilaiMDAkhir);
        print("######Identifikasi  hasil MD ${[nilaiMDAkhir, index]} ");
      }
      index++;
    });
    nilaiMD = nilaiMDAkhir;
  }

  void hitungCF() {
    nilaiCF = nilaiMB - nilaiMD;
    print("######Identifikasi.hitungCF ${[nilaiCF]} ");
  }

  Tingkatan ambilHasil() {
    Tingkatan hasil = Tingkatan("ERROR", RangeValues(0, 0));
    tingkatan.map((tingkatan) {
      if (nilaiCF >= tingkatan.range.start && nilaiCF <= tingkatan.range.end) {
        hasil = tingkatan;
      }
    }).toList();

    return hasil;
  }
}
