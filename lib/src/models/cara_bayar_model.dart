CaraBayarModel caraBayarModelFromJson(dynamic str) =>
    CaraBayarModel.fromJson(str);

class CaraBayarModel {
  bool? success;
  int? total;
  List<CaraBayar>? caraBayar;

  CaraBayarModel({
    this.success,
    this.total,
    this.caraBayar,
  });

  factory CaraBayarModel.fromJson(Map<String, dynamic> json) => CaraBayarModel(
        success: json["success"],
        total: json["total"],
        caraBayar: !json["success"]
            ? null
            : List<CaraBayar>.from(
                json["data"].map((x) => CaraBayar.fromJson(x))),
      );
}

class CaraBayar {
  String? id;
  String? deskripsi;
  String? status;

  CaraBayar({
    this.id,
    this.deskripsi,
    this.status,
  });

  factory CaraBayar.fromJson(Map<String, dynamic> json) => CaraBayar(
        id: json["ID"],
        deskripsi: json["DESKRIPSI"],
        status: json["STATUS"],
      );
}
