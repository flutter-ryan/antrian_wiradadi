JadwalDokterHafisModel jadwalDokterHafisModelFromJson(dynamic str) =>
    JadwalDokterHafisModel.fromJson(str);

class JadwalDokterHafisModel {
  JadwalDokterHafisModel({
    this.status,
    this.success,
    this.total,
    this.jadwalDokter,
  });

  int? status;
  bool? success;
  int? total;
  List<JadwalDokter>? jadwalDokter;

  factory JadwalDokterHafisModel.fromJson(Map<String, dynamic> json) =>
      JadwalDokterHafisModel(
        status: json["status"],
        success: json["success"],
        total: json["total"],
        jadwalDokter: json["success"]
            ? List<JadwalDokter>.from(
                json["data"].map((x) => JadwalDokter.fromJson(x)))
            : null,
      );
}

class JadwalDokter {
  JadwalDokter({
    this.id,
    this.kdDokter,
    this.nmDokter,
    this.kdSubSpesialis,
    this.kdPoli,
    this.hari,
    this.nmHari,
    this.jam,
    this.jamMulai,
    this.jamSelesai,
    this.kapasitas,
    this.libur,
    this.status,
    this.referensi,
  });

  String? id;
  String? kdDokter;
  String? nmDokter;
  String? kdSubSpesialis;
  String? kdPoli;
  String? hari;
  String? nmHari;
  String? jam;
  String? jamMulai;
  String? jamSelesai;
  String? kapasitas;
  String? libur;
  String? status;
  Referensi? referensi;

  factory JadwalDokter.fromJson(Map<String, dynamic> json) => JadwalDokter(
        id: json["ID"],
        kdDokter: json["KD_DOKTER"],
        nmDokter: json["NM_DOKTER"],
        kdSubSpesialis: json["KD_SUB_SPESIALIS"],
        kdPoli: json["KD_POLI"],
        hari: json["HARI"],
        nmHari: json["NM_HARI"],
        jam: json["JAM"],
        jamMulai: json["JAM_MULAI"],
        jamSelesai: json["JAM_SELESAI"],
        kapasitas: json["KAPASITAS"],
        libur: json["LIBUR"],
        status: json["STATUS"],
        referensi: Referensi.fromJson(json["REFERENSI"]),
      );
}

class Referensi {
  Referensi({
    this.poli,
    this.subspesialis,
  });

  Poli? poli;
  Poli? subspesialis;

  factory Referensi.fromJson(Map<String, dynamic> json) => Referensi(
        poli: Poli.fromJson(json["POLI"]),
        subspesialis: Poli.fromJson(json["SUBSPESIALIS"]),
      );
}

class Poli {
  Poli({
    this.kdpoli,
    this.nmpoli,
    this.antrian,
    this.status,
  });

  String? kdpoli;
  String? nmpoli;
  String? antrian;
  String? status;

  factory Poli.fromJson(Map<String, dynamic> json) => Poli(
        kdpoli: json["KDPOLI"],
        nmpoli: json["NMPOLI"],
        antrian: json["ANTRIAN"],
        status: json["STATUS"],
      );
}
