PoliklinikModel poliklinikModelFromJson(dynamic str) =>
    PoliklinikModel.fromJson(str);

class PoliklinikModel {
  bool success;
  int total;
  List<Poliklinik> poli;

  PoliklinikModel({
    this.success,
    this.total,
    this.poli,
  });

  factory PoliklinikModel.fromJson(Map<String, dynamic> json) =>
      PoliklinikModel(
        success: json["success"],
        total: json["total"],
        poli: List<Poliklinik>.from(
            json["data"].map((x) => Poliklinik.fromJson(x))),
      );
}

class Poliklinik {
  String id;
  String deskripsi;
  String antrian;
  String status;

  Poliklinik({
    this.id,
    this.deskripsi,
    this.antrian,
    this.status,
  });

  factory Poliklinik.fromJson(Map<String, dynamic> json) => Poliklinik(
        id: json["ID"],
        deskripsi: json["DESKRIPSI"],
        antrian: json["ANTRIAN"],
        status: json["STATUS"],
      );
}
