TempatTidurModel tempatTidurModelFromJson(dynamic str) =>
    TempatTidurModel.fromJson(str);

class TempatTidurModel {
  TempatTidurModel({
    this.success,
    this.response,
    this.metadata,
  });

  bool success;
  List<TempatTidur> response;
  Metadata metadata;

  factory TempatTidurModel.fromJson(Map<String, dynamic> json) =>
      TempatTidurModel(
        success: json["success"],
        response: List<TempatTidur>.from(
            json["response"].map((x) => TempatTidur.fromJson(x))),
        metadata: Metadata.fromJson(json["metadata"]),
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

class TempatTidur {
  TempatTidur({
    this.kamar,
    this.kosong,
    this.terisi,
    this.total,
  });

  String kamar;
  String kosong;
  String terisi;
  String total;

  factory TempatTidur.fromJson(Map<String, dynamic> json) => TempatTidur(
        kamar: json["KAMAR"],
        kosong: json["KOSONG"],
        terisi: json["TERISI"],
        total: json["TOTAL"],
      );
}
