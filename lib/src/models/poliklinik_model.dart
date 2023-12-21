PoliklinikModel poliklinikModelFromJson(dynamic str) =>
    PoliklinikModel.fromJson(str);

class PoliklinikModel {
  PoliklinikModel({
    this.success = false,
    this.total,
    this.poliklinik,
  });

  bool success;
  int? total;
  List<Poliklinik>? poliklinik;

  factory PoliklinikModel.fromJson(Map<String, dynamic> json) =>
      PoliklinikModel(
        success: json["success"],
        total: json["total"],
        poliklinik: json["success"]
            ? List<Poliklinik>.from(
                json["data"].map((x) => Poliklinik.fromJson(x)))
            : null,
      );
}

class Poliklinik {
  Poliklinik({
    this.id,
    this.deskripsi,
    this.antrian,
    this.status,
    this.limitDaftar,
    this.durasiPendaftaran,
    this.durasiPelayanan,
    this.mulai,
    this.jumlahMeja,
    this.referensi,
  });

  String? id;
  String? deskripsi;
  String? antrian;
  String? status;
  String? limitDaftar;
  String? durasiPendaftaran;
  String? durasiPelayanan;
  String? mulai;
  String? jumlahMeja;
  Referensi? referensi;

  factory Poliklinik.fromJson(Map<String, dynamic> json) => Poliklinik(
        id: json["ID"],
        deskripsi: json["DESKRIPSI"],
        antrian: json["ANTRIAN"],
        status: json["STATUS"],
        limitDaftar: json["LIMIT_DAFTAR"],
        durasiPendaftaran: json["DURASI_PENDAFTARAN"],
        durasiPelayanan: json["DURASI_PELAYANAN"],
        mulai: json["MULAI"],
        jumlahMeja: json["JUMLAH_MEJA"],
        referensi: json["REFERENSI"] == null
            ? null
            : Referensi.fromJson(json["REFERENSI"]),
      );
}

class Referensi {
  Referensi({
    this.penjamin,
    this.penjaminRuangan,
  });

  Penjamin? penjamin;
  String? penjaminRuangan;

  factory Referensi.fromJson(Map<String, dynamic> json) => Referensi(
        penjamin: json["PENJAMIN"] == null
            ? null
            : Penjamin.fromJson(json["PENJAMIN"]),
        penjaminRuangan: json["PENJAMIN_RUANGAN"],
      );
}

class Penjamin {
  Penjamin({
    this.id,
    this.penjamin,
    this.ruanganPenjamin,
    this.ruanganRs,
    this.status,
    this.bpjs,
  });

  String? id;
  String? penjamin;
  String? ruanganPenjamin;
  String? ruanganRs;
  String? status;
  Bpjs? bpjs;

  factory Penjamin.fromJson(Map<String, dynamic> json) => Penjamin(
        id: json["ID"],
        penjamin: json["PENJAMIN"],
        ruanganPenjamin: json["RUANGAN_PENJAMIN"],
        ruanganRs: json["RUANGAN_RS"],
        status: json["STATUS"],
        bpjs: json["BPJS"] == null ? null : Bpjs.fromJson(json["BPJS"]),
      );
}

class Bpjs {
  Bpjs({
    this.kdpoli,
    this.nmpoli,
    this.antrian,
    this.status,
  });

  String? kdpoli;
  String? nmpoli;
  String? antrian;
  String? status;

  factory Bpjs.fromJson(Map<String, dynamic> json) => Bpjs(
        kdpoli: json["KDPOLI"],
        nmpoli: json["NMPOLI"],
        antrian: json["ANTRIAN"],
        status: json["STATUS"],
      );
}
