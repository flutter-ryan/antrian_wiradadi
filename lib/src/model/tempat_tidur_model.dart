import 'dart:convert';

TempatTidurModel tempatTidurModelFromJson(dynamic str) =>
    TempatTidurModel.fromJson(str);

class TempatTidurModel {
  TempatTidurModel({
    this.success,
    this.response,
    this.metadata,
  });

  bool success;
  List<Response> response;
  Metadata metadata;

  factory TempatTidurModel.fromJson(Map<String, dynamic> json) =>
      TempatTidurModel(
        success: json["success"],
        response: List<Response>.from(
            json["response"].map((x) => Response.fromJson(x))),
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

class Response {
  Response({
    this.kamar,
    this.kosong,
    this.terisi,
    this.total,
  });

  String kamar;
  String kosong;
  String terisi;
  String total;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        kamar: json["KAMAR"],
        kosong: json["KOSONG"],
        terisi: json["TERISI"],
        total: json["TOTAL"],
      );
}
