PosAntrianModel posAntrianModelFromJson(dynamic str) =>
    PosAntrianModel.fromJson(str);

class PosAntrianModel {
  PosAntrianModel({
    this.success = false,
    this.total,
    this.posAntrian,
  });

  bool success;
  int? total;
  List<PosAntrian>? posAntrian;

  factory PosAntrianModel.fromJson(Map<String, dynamic> json) =>
      PosAntrianModel(
        success: json["success"],
        total: json["total"],
        posAntrian: json["success"]
            ? List<PosAntrian>.from(
                json["data"].map((x) => PosAntrian.fromJson(x)))
            : null,
      );
}

class PosAntrian {
  PosAntrian({
    this.nomor,
    this.deskripsi,
    this.status,
    this.panggil,
  });

  String? nomor;
  String? deskripsi;
  String? status;
  String? panggil;

  factory PosAntrian.fromJson(Map<String, dynamic> json) => PosAntrian(
        nomor: json["NOMOR"],
        deskripsi: json["DESKRIPSI"],
        status: json["STATUS"],
        panggil: json["PANGGIL"],
      );
}
