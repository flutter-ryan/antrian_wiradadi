import 'dart:convert';

String createAntrianModelToJson(CreateAntrianModel data) =>
    json.encode(data.toJson());

class CreateAntrianModel {
  String jenis;
  String norm;
  String nama;
  String tanggalLahir;
  String contact;
  String poli;
  String carabayar;
  String tanggalkunjugan;
  int jenisAplikasi;
  int status;

  CreateAntrianModel({
    this.jenis,
    this.norm,
    this.nama,
    this.tanggalLahir,
    this.contact,
    this.poli,
    this.carabayar,
    this.tanggalkunjugan,
    this.jenisAplikasi,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        "JENIS": jenis,
        "NORM": norm,
        "NAMA": nama,
        "TANGGAL_LAHIR": tanggalLahir,
        "CONTACT": contact,
        "POLI": poli,
        "CARABAYAR": carabayar,
        "TANGGALKUNJUNGAN": tanggalkunjugan,
        "JENIS_APLIKASI": jenisAplikasi,
        "STATUS": status,
      };
}

ResponseCreateAntrianModel responseCreateAntrianModelFromJson(dynamic str) =>
    ResponseCreateAntrianModel.fromJson(str);

class ResponseCreateAntrianModel {
  bool success;
  Response response;
  Metadata metadata;

  ResponseCreateAntrianModel({
    this.success,
    this.response,
    this.metadata,
  });

  factory ResponseCreateAntrianModel.fromJson(Map<String, dynamic> json) =>
      ResponseCreateAntrianModel(
        success: json["success"],
        response:
            json["response"] == "" ? null : Response.fromJson(json["response"]),
        metadata: Metadata.fromJson(json["metadata"]),
      );
}

class Metadata {
  String message;
  int code;

  Metadata({
    this.message,
    this.code,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        message: json["message"],
        code: json["code"],
      );
}

class Response {
  String nomorantrean;
  String kodebooking;
  int jenisantrean;
  int estimasidilayani;
  String tanggalkunjungan;
  String jamkunjungan;
  String namapoli;
  String namadokter;
  String namapasien;

  Response({
    this.nomorantrean,
    this.kodebooking,
    this.jenisantrean,
    this.estimasidilayani,
    this.tanggalkunjungan,
    this.jamkunjungan,
    this.namapoli,
    this.namadokter,
    this.namapasien,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        nomorantrean: json["nomorantrean"],
        kodebooking: json["kodebooking"],
        jenisantrean: json["jenisantrean"],
        estimasidilayani: json["estimasidilayani"],
        tanggalkunjungan: json["tanggalkunjungan"],
        jamkunjungan: json["jamkunjungan"],
        namapoli: json["namapoli"],
        namapasien: json["namapasien"],
      );
}
