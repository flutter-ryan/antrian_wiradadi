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
  String idJadwal;
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
    this.idJadwal,
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
        "JADWAL_DOKTER": idJadwal,
        "TANGGALKUNJUNGAN": tanggalkunjugan,
        "JENIS_APLIKASI": jenisAplikasi,
        "STATUS": status,
      };
}

ResponseCreateAntrianModel responseCreateAntrianModelFromJson(dynamic str) =>
    ResponseCreateAntrianModel.fromJson(str);

class ResponseCreateAntrianModel {
  ResponseCreateAntrianModel({
    this.success,
    this.response,
    this.metadata,
  });

  bool success;
  Antrian response;
  Metadata metadata;

  factory ResponseCreateAntrianModel.fromJson(Map<String, dynamic> json) =>
      ResponseCreateAntrianModel(
        success: json["success"],
        response: Antrian?.fromJson(json["response"]),
        metadata: Metadata?.fromJson(json["metadata"]),
      );
}

class Metadata {
  Metadata({
    this.message,
    this.code,
  });

  String message;
  int code;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        message: json["message"],
        code: json["code"],
      );
}

class Antrian {
  Antrian({
    this.nomorantrean,
    this.kodebooking,
    this.jenisantrean,
    this.estimasidilayani,
    this.tanggalkunjungan,
    this.jamkunjungan,
    this.namapoli,
    this.namadokter,
    this.namapasien,
    this.selisih,
    this.jadwaldokter,
  });

  String nomorantrean;
  String kodebooking;
  int jenisantrean;
  int estimasidilayani;
  String tanggalkunjungan;
  String jamkunjungan;
  String namapoli;
  String namadokter;
  String namapasien;
  int selisih;
  Jadwaldokter jadwaldokter;

  factory Antrian.fromJson(Map<String, dynamic> json) => Antrian(
        nomorantrean: json["nomorantrean"],
        kodebooking: json["kodebooking"],
        jenisantrean: json["jenisantrean"],
        estimasidilayani: json["estimasidilayani"],
        tanggalkunjungan: json["tanggalkunjungan"],
        jamkunjungan: json["jamkunjungan"],
        namapoli: json["namapoli"],
        namadokter: json["namadokter"],
        namapasien: json["namapasien"],
        selisih: json["selisih"],
        jadwaldokter: Jadwaldokter?.fromJson(json["jadwaldokter"]),
      );
}

class Jadwaldokter {
  Jadwaldokter({
    this.id,
    this.dokter,
    this.ruangan,
    this.hari,
    this.mulai,
    this.selesai,
    this.status,
    this.deskHari,
    this.namaDokter,
    this.jenisKelamin,
  });

  String id;
  String dokter;
  String ruangan;
  String hari;
  String mulai;
  String selesai;
  String status;
  String deskHari;
  String namaDokter;
  String jenisKelamin;

  factory Jadwaldokter.fromJson(Map<String, dynamic> json) => Jadwaldokter(
        id: json["ID"],
        dokter: json["DOKTER"],
        ruangan: json["RUANGAN"],
        hari: json["HARI"],
        mulai: json["MULAI"],
        selesai: json["SELESAI"],
        status: json["STATUS"],
        deskHari: json["DESK_HARI"],
        namaDokter: json["NAMA_DOKTER"],
        jenisKelamin: json["JENIS_KELAMIN"],
      );
}
