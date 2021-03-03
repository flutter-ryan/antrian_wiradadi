JadwalDokterModel jadwalDokterModelFromJson(dynamic str) =>
    JadwalDokterModel.fromJson(str);

class JadwalDokterModel {
  JadwalDokterModel({
    this.status,
    this.success,
    this.total,
    this.data,
    this.detail,
  });

  int status;
  bool success;
  int total;
  List<Dokter> data;
  String detail;

  factory JadwalDokterModel.fromJson(Map<String, dynamic> json) =>
      JadwalDokterModel(
        status: json["status"],
        success: json["success"],
        total: json["total"],
        data: json["data"] == null
            ? null
            : List<Dokter>.from(json["data"].map((x) => Dokter.fromJson(x))),
        detail: json["detail"],
      );
}

class Dokter {
  Dokter({
    this.dokter,
    this.ruangan,
    this.status,
    this.namaDokter,
    this.jadwal,
  });

  String dokter;
  String ruangan;
  String status;
  String namaDokter;
  List<Jadwal> jadwal;

  factory Dokter.fromJson(Map<String, dynamic> json) => Dokter(
        dokter: json["DOKTER"],
        ruangan: json["RUANGAN"],
        status: json["STATUS"],
        namaDokter: json["NAMA_DOKTER"],
        jadwal:
            List<Jadwal>.from(json["JADWAL"].map((x) => Jadwal.fromJson(x))),
      );
}

class Jadwal {
  Jadwal({
    this.id,
    this.hari,
    this.mulai,
    this.selesai,
    this.deskHari,
  });

  String id;
  String hari;
  String mulai;
  String selesai;
  String deskHari;

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        id: json["ID"],
        hari: json["HARI"],
        mulai: json["MULAI"],
        selesai: json["SELESAI"],
        deskHari: json["DESK_HARI"],
      );
}
