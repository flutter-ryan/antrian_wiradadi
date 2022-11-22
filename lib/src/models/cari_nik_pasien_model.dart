import 'dart:convert';

String cariNikPasienModelToJson(CariNikPasienModel data) =>
    json.encode(data.toJson());

class CariNikPasienModel {
  String nik;
  String tanggalLahir;

  CariNikPasienModel({
    required this.nik,
    required this.tanggalLahir,
  });

  Map<String, dynamic> toJson() => {
        "NIK": nik,
        "TANGGAL_LAHIR": tanggalLahir,
      };
}
