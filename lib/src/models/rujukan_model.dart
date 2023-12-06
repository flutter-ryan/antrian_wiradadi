RujukanModel rujukanModelFromJson(dynamic str) => RujukanModel.fromJson(str);

class RujukanModel {
  RujukanModel({
    this.status,
    this.success,
    this.data,
  });

  String? status;
  bool? success;
  DataRujukan? data;

  factory RujukanModel.fromJson(Map<String, dynamic> json) => RujukanModel(
        status: json["status"],
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
    this.poliRujukan,
    this.pelayanan,
  });

  String? noKunjungan;
  DateTime? tglKunjungan;
  Pelayanan? provPerujuk;
  Peserta? peserta;
  Pelayanan? poliRujukan;
  Pelayanan? pelayanan;

  factory Rujukan.fromJson(Map<String, dynamic> json) => Rujukan(
        noKunjungan: json["noKunjungan"],
        tglKunjungan: DateTime.parse(json["tglKunjungan"]),
        provPerujuk: Pelayanan.fromJson(json["provPerujuk"]),
        peserta: Peserta.fromJson(json["peserta"]),
        poliRujukan: Pelayanan.fromJson(json["poliRujukan"]),
        pelayanan: Pelayanan.fromJson(json["pelayanan"]),
      );
}

class Pelayanan {
  Pelayanan({
    this.kode,
    this.nama,
  });

  String? kode;
  String? nama;

  factory Pelayanan.fromJson(Map<String, dynamic> json) => Pelayanan(
        kode: json["kode"],
        nama: json["nama"],
      );
}

class Peserta {
  Peserta({
    this.noKartu,
    this.nik,
    this.nama,
    this.tglLahir,
    this.tglCetakKartu,
  });

  String? noKartu;
  String? nik;
  String? nama;
  DateTime? tglLahir;
  DateTime? tglCetakKartu;

  factory Peserta.fromJson(Map<String, dynamic> json) => Peserta(
        noKartu: json["noKartu"],
        nik: json["nik"],
        nama: json["nama"],
        tglLahir: DateTime.parse(json["tglLahir"]),
        tglCetakKartu: DateTime.parse(json["tglCetakKartu"]),
      );
}
