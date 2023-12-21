import 'dart:convert';

String cariPasienModelToJson(CariPasienModel data) =>
    json.encode(data.toJson());

class CariPasienModel {
  String norm;
  String tanggalLahir;

  CariPasienModel({
    required this.norm,
    required this.tanggalLahir,
  });

  Map<String, dynamic> toJson() => {
        "NORM": norm,
        "TANGGAL_LAHIR": tanggalLahir,
      };
}

ResponseCariPasienModel responseCariPasienModelFromJson(dynamic str) =>
    ResponseCariPasienModel.fromJson(str);

class ResponseCariPasienModel {
  bool success;
  int total;
  List<Pasien>? pasien;

  ResponseCariPasienModel({
    required this.success,
    required this.total,
    this.pasien,
  });

  factory ResponseCariPasienModel.fromJson(Map<String, dynamic> json) =>
      ResponseCariPasienModel(
        success: json["success"],
        total: json["total"],
        pasien: (!json["success"])
            ? null
            : List<Pasien>.from(json["data"].map((x) => Pasien.fromJson(x))),
      );
}

class Pasien {
  String? norm;
  String? nama;
  String? tanggalLahir;
  List<KartuIdentitas>? kartuIdentitas;
  List<KartuAsuransi>? kartuAsuransi;
  List<KontakPasien>? kontakPasien;

  Pasien({
    this.norm,
    this.nama,
    this.tanggalLahir,
    this.kartuIdentitas,
    this.kartuAsuransi,
    this.kontakPasien,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        norm: json["NORM"],
        nama: json["NAMA"],
        tanggalLahir: json["TANGGAL_LAHIR"],
        kartuIdentitas: json.containsKey("KARTUIDENTITAS")
            ? List<KartuIdentitas>.from(
                json["KARTUIDENTITAS"].map((x) => KartuIdentitas.fromJson(x)))
            : null,
        kartuAsuransi: json.containsKey("KARTUASURANSI")
            ? List<KartuAsuransi>.from(
                json["KARTUASURANSI"].map((x) => KartuAsuransi.fromJson(x)))
            : null,
        kontakPasien: json.containsKey("KONTAK")
            ? List<KontakPasien>.from(
                json["KONTAK"].map((x) => KontakPasien.fromJson(x)))
            : null,
      );
}

class KartuIdentitas {
  String? jenis;
  String? nomor;

  KartuIdentitas({
    this.jenis,
    this.nomor,
  });

  factory KartuIdentitas.fromJson(Map<String, dynamic> json) => KartuIdentitas(
        jenis: json["JENIS"],
        nomor: json["NOMOR"],
      );
}

class KartuAsuransi {
  String? jenis;
  String? nomor;

  KartuAsuransi({
    this.jenis,
    this.nomor,
  });

  factory KartuAsuransi.fromJson(Map<String, dynamic> json) => KartuAsuransi(
        jenis: json["JENIS"],
        nomor: json["NOMOR"],
      );
}

class KontakPasien {
  String? jenis;
  String? nomor;

  KontakPasien({
    this.jenis,
    this.nomor,
  });

  factory KontakPasien.fromJson(Map<String, dynamic> json) => KontakPasien(
        jenis: json["JENIS"],
        nomor: json["NOMOR"],
      );
}
