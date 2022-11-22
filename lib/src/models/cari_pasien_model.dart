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
  String? panggilan;
  String? gelarDepan;
  String? gelarBelakang;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? alamat;
  String? rt;
  String? rw;
  String? kodepos;
  String? wilayah;
  String? agama;
  String? pendidikan;
  String? pekerjaan;
  String? statusPerkawinan;
  String? golonganDarah;
  String? kewarganegaraan;
  String? suku;
  String? tanggal;
  String? oleh;
  String? status;

  Pasien({
    this.norm,
    this.nama,
    this.panggilan,
    this.gelarDepan,
    this.gelarBelakang,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.alamat,
    this.rt,
    this.rw,
    this.kodepos,
    this.wilayah,
    this.agama,
    this.pendidikan,
    this.pekerjaan,
    this.statusPerkawinan,
    this.golonganDarah,
    this.kewarganegaraan,
    this.suku,
    this.tanggal,
    this.oleh,
    this.status,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        norm: json["NORM"],
        nama: json["NAMA"],
        panggilan: json["PANGGILAN"],
        gelarDepan: json["GELAR_DEPAN"],
        gelarBelakang: json["GELAR_BELAKANG"],
        tempatLahir: json["TEMPAT_LAHIR"],
        tanggalLahir: json["TANGGAL_LAHIR"],
        jenisKelamin: json["JENIS_KELAMIN"],
        alamat: json["ALAMAT"],
        rt: json["RT"],
        rw: json["RW"],
        kodepos: json["KODEPOS"],
        wilayah: json["WILAYAH"],
        agama: json["AGAMA"],
        pendidikan: json["PENDIDIKAN"],
        pekerjaan: json["PEKERJAAN"],
        statusPerkawinan: json["STATUS_PERKAWINAN"],
        golonganDarah: json["GOLONGAN_DARAH"],
        kewarganegaraan: json["KEWARGANEGARAAN"],
        suku: json["SUKU"],
        tanggal: json["TANGGAL"],
        oleh: json["OLEH"],
        status: json["STATUS"],
      );
}
