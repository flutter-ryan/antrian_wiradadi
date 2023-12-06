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
    this.jenispasien,
    this.nomorkartu,
    this.nik,
    this.nohp,
    this.kodepoli,
    this.namapoli,
    this.norm,
    this.nama,
    this.tanggalperiksa,
    this.kodedokter,
    this.namadokter,
    this.jampraktek,
    this.jeniskunjungan,
    this.nomorreferensi,
    this.nomorantrean,
    this.angkaantrean,
    this.estimasidilayani,
    this.kodepolirs,
    this.keterangan,
    this.antreanpoli,
  });

  String? kodebooking;
  String? jenispasien;
  String? nomorkartu;
  String? nik;
  String? nohp;
  String? kodepoli;
  String? namapoli;
  dynamic norm;
  String? nama;
  String? tanggalperiksa;
  String? kodedokter;
  String? namadokter;
  String? jampraktek;
  int? jeniskunjungan;
  String? nomorreferensi;
  String? nomorantrean;
  String? angkaantrean;
  int? estimasidilayani;
  String? kodepolirs;
  String? keterangan;
  String? antreanpoli;

  factory Antrian.fromJson(Map<String, dynamic> json) => Antrian(
        kodebooking: json["kodebooking"],
        jenispasien: json["jenispasien"],
        nomorkartu: json["nomorkartu"],
        nik: json["nik"],
        nohp: json["nohp"],
        kodepoli: json["kodepoli"],
        namapoli: json["namapoli"],
        norm: json["norm"],
        nama: json["nama"],
        tanggalperiksa: json["tanggalkunjungan"],
        kodedokter: json["kodedokter"],
        namadokter: json["namadokter"],
        jampraktek: json["jampraktek"],
        jeniskunjungan: json["jeniskunjungan"],
        nomorreferensi: json["nomorreferensi"],
        nomorantrean: json["nomorantrean"],
        angkaantrean: json["angkaantrean"],
        estimasidilayani: json["estimasidilayani"],
        kodepolirs: json["kodepolirs"],
        keterangan: json["keterangan"],
        antreanpoli: json["antreanpoli"],
      );
}
