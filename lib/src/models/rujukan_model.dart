RujukanModel rujukanModelFromJson(dynamic str) => RujukanModel.fromJson(str);

class RujukanModel {
  RujukanModel({
    this.success,
    this.data,
  });

  bool? success;
  DataRujukan? data;

  factory RujukanModel.fromJson(Map<String, dynamic> json) => RujukanModel(
        success: json["success"],
        data: json["success"] ? DataRujukan.fromJson(json["data"]) : null,
      );
}

class DataRujukan {
  DataRujukan({
    this.asalFaskes,
    this.rujukan,
  });

  String? asalFaskes;
  List<Rujukan>? rujukan;

  factory DataRujukan.fromJson(Map<String, dynamic> json) => DataRujukan(
        asalFaskes: json["asalFaskes"],
        rujukan:
            List<Rujukan>.from(json["rujukan"].map((x) => Rujukan.fromJson(x))),
      );
}

class Rujukan {
  Rujukan({
    this.noKunjungan,
    this.tglKunjungan,
    this.provPerujuk,
    this.peserta,
    this.diagnosa,
    this.keluhan,
    this.poliRujukan,
    this.pelayanan,
  });

  String? noKunjungan;
  DateTime? tglKunjungan;
  Diagnosa? provPerujuk;
  Peserta? peserta;
  Diagnosa? diagnosa;
  String? keluhan;
  Diagnosa? poliRujukan;
  Diagnosa? pelayanan;

  factory Rujukan.fromJson(Map<String, dynamic> json) => Rujukan(
        noKunjungan: json["noKunjungan"],
        tglKunjungan: DateTime.parse(json["tglKunjungan"]),
        provPerujuk: Diagnosa.fromJson(json["provPerujuk"]),
        peserta: Peserta.fromJson(json["peserta"]),
        diagnosa: Diagnosa.fromJson(json["diagnosa"]),
        keluhan: json["keluhan"],
        poliRujukan: Diagnosa.fromJson(json["poliRujukan"]),
        pelayanan: Diagnosa.fromJson(json["pelayanan"]),
      );
}

class Diagnosa {
  Diagnosa({
    this.kode,
    this.nama,
  });

  String? kode;
  String? nama;

  factory Diagnosa.fromJson(Map<String, dynamic> json) => Diagnosa(
        kode: json["kode"],
        nama: json["nama"],
      );
}

class Peserta {
  Peserta({
    this.noKartu,
    this.nik,
    this.nama,
    this.pisa,
    this.sex,
    this.mr,
    this.tglLahir,
    this.tglCetakKartu,
    this.tglTat,
    this.tglTmt,
    this.statusPeserta,
    this.provUmum,
    this.jenisPeserta,
    this.hakKelas,
    this.umur,
    this.informasi,
    this.cob,
  });

  String? noKartu;
  String? nik;
  String? nama;
  String? pisa;
  String? sex;
  Mr? mr;
  DateTime? tglLahir;
  DateTime? tglCetakKartu;
  DateTime? tglTat;
  DateTime? tglTmt;
  HakKelas? statusPeserta;
  ProvUmum? provUmum;
  HakKelas? jenisPeserta;
  HakKelas? hakKelas;
  Umur? umur;
  Informasi? informasi;
  Cob? cob;

  factory Peserta.fromJson(Map<String, dynamic> json) => Peserta(
        noKartu: json["noKartu"],
        nik: json["nik"],
        nama: json["nama"],
        pisa: json["pisa"],
        sex: json["sex"],
        mr: Mr.fromJson(json["mr"]),
        tglLahir: DateTime.parse(json["tglLahir"]),
        tglCetakKartu: DateTime.parse(json["tglCetakKartu"]),
        tglTat: DateTime.parse(json["tglTAT"]),
        tglTmt: DateTime.parse(json["tglTMT"]),
        statusPeserta: HakKelas.fromJson(json["statusPeserta"]),
        provUmum: ProvUmum.fromJson(json["provUmum"]),
        jenisPeserta: HakKelas.fromJson(json["jenisPeserta"]),
        hakKelas: HakKelas.fromJson(json["hakKelas"]),
        umur: Umur.fromJson(json["umur"]),
        informasi: Informasi.fromJson(json["informasi"]),
        cob: Cob.fromJson(json["cob"]),
      );
}

class Cob {
  Cob({
    this.noAsuransi,
    this.nmAsuransi,
    this.tglTmt,
    this.tglTat,
  });

  dynamic noAsuransi;
  dynamic nmAsuransi;
  dynamic tglTmt;
  dynamic tglTat;

  factory Cob.fromJson(Map<String, dynamic> json) => Cob(
        noAsuransi: json["noAsuransi"],
        nmAsuransi: json["nmAsuransi"],
        tglTmt: json["tglTMT"],
        tglTat: json["tglTAT"],
      );
}

class HakKelas {
  HakKelas({
    this.kode,
    this.keterangan,
  });

  String? kode;
  String? keterangan;

  factory HakKelas.fromJson(Map<String, dynamic> json) => HakKelas(
        kode: json["kode"],
        keterangan: json["keterangan"],
      );
}

class Informasi {
  Informasi({
    this.dinsos,
    this.prolanisPrb,
    this.noSktm,
  });

  dynamic dinsos;
  dynamic prolanisPrb;
  dynamic noSktm;

  factory Informasi.fromJson(Map<String, dynamic> json) => Informasi(
        dinsos: json["dinsos"],
        prolanisPrb: json["prolanisPRB"],
        noSktm: json["noSKTM"],
      );
}

class Mr {
  Mr({
    this.noMr,
    this.noTelepon,
  });

  String? noMr;
  String? noTelepon;

  factory Mr.fromJson(Map<String, dynamic> json) => Mr(
        noMr: json["noMR"],
        noTelepon: json["noTelepon"],
      );
}

class ProvUmum {
  ProvUmum({
    this.kdProvider,
    this.nmProvider,
  });

  String? kdProvider;
  String? nmProvider;

  factory ProvUmum.fromJson(Map<String, dynamic> json) => ProvUmum(
        kdProvider: json["kdProvider"],
        nmProvider: json["nmProvider"],
      );
}

class Umur {
  Umur({
    this.umurSekarang,
    this.umurSaatPelayanan,
  });

  String? umurSekarang;
  String? umurSaatPelayanan;

  factory Umur.fromJson(Map<String, dynamic> json) => Umur(
        umurSekarang: json["umurSekarang"],
        umurSaatPelayanan: json["umurSaatPelayanan"],
      );
}
