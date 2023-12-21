import 'dart:convert';

String pendaftaranPasienModelToJson(PendaftaranPasienModel data) =>
    json.encode(data.toJson());

class PendaftaranPasienModel {
  PendaftaranPasienModel({
    required this.jenis,
    required this.nama,
    required this.noKartuBpjs,
    required this.noRefBpjs,
    required this.norm,
    required this.nik,
    required this.tanggalLahir,
    required this.contact,
    required this.poli,
    required this.poliBpjs,
    required this.carabayar,
    required this.dokter,
    required this.tanggalkunjungan,
    required this.jamPraktek,
    required this.jenisAplikasi,
    required this.status,
  });

  String jenis;
  String nama;
  String noKartuBpjs;
  String noRefBpjs;
  String norm;
  String nik;
  String tanggalLahir;
  String contact;
  String poli;
  String poliBpjs;
  String carabayar;
  String dokter;
  String tanggalkunjungan;
  String jamPraktek;
  int jenisAplikasi;
  int status;

  Map<String, dynamic> toJson() => {
        "JENIS": jenis,
        "NAMA": nama,
        "NO_KARTU_BPJS": noKartuBpjs,
        "NO_REF_BPJS": noRefBpjs,
        "NORM": norm,
        "NIK": nik,
        "TANGGAL_LAHIR": tanggalLahir,
        "CONTACT": contact,
        "POLI": poli,
        "POLI_BPJS": poliBpjs,
        "CARABAYAR": carabayar,
        "DOKTER": dokter,
        "TANGGALKUNJUNGAN": tanggalkunjungan,
        "JAM_PRAKTEK": jamPraktek,
        "JENIS_APLIKASI": jenisAplikasi,
        "STATUS": status,
      };
}

ResponsePendaftaranPasienModel responsePendaftaranPasienModelFromJson(
        dynamic str) =>
    ResponsePendaftaranPasienModel.fromJson(str);

class ResponsePendaftaranPasienModel {
  ResponsePendaftaranPasienModel({
    this.success,
    this.antrian,
    this.metadata,
  });

  bool? success;
  Antrian? antrian;
  Metadata? metadata;

  factory ResponsePendaftaranPasienModel.fromJson(Map<String, dynamic> json) =>
      ResponsePendaftaranPasienModel(
        success: json["success"],
        antrian: json['success'] ? Antrian.fromJson(json["response"]) : null,
        metadata: Metadata.fromJson(json["metadata"]),
      );
}

class Metadata {
  Metadata({
    this.message,
    this.code,
  });

  String? message;
  int? code;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        message: json["message"],
        code: json["code"],
      );
}

class Antrian {
  Antrian({
    this.kodebooking,
    this.namapoli,
    this.nama,
    this.tanggalperiksa,
    this.jampraktek,
    this.nomorantrean,
    this.estimasidilayani,
    this.antreanpoli,
    this.namadokter,
  });

  String? kodebooking;
  String? namapoli;
  String? nama;
  String? tanggalperiksa;
  String? jampraktek;
  String? nomorantrean;
  String? estimasidilayani;
  String? antreanpoli;
  String? namadokter;

  factory Antrian.fromJson(Map<String, dynamic> json) => Antrian(
        kodebooking: json["kodebooking"],
        namapoli: json["namapoli"],
        nama: json["nama"],
        tanggalperiksa: json["tanggalperiksa"],
        jampraktek: json["jampraktekdpjp"],
        nomorantrean: json["nomorantrean"],
        estimasidilayani: json["estimasijampelayanan"],
        antreanpoli: json["antreanpoli"],
        namadokter: json["namadokter"],
      );
}
