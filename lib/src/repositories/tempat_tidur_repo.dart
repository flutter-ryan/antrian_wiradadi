import 'dart:convert';

import 'package:antrian_wiradadi/src/models/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class TempatTidurRepo {
  Future<TempatTidurModel> getTempatTidur(String token) async {
    final response = await dio.post('getKetersediaanTempatTidur',
        jsonEncode({"VIEW_KETERSEDIAAN_TEMPAT_TIDUR": 1}), false, token);
    return tempatTidurModelFromJson(response);
  }
}
