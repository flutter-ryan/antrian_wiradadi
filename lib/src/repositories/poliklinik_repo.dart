import 'package:antrian_wiradadi/src/models/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class PoliklinikRepo {
  Future<PoliklinikModel> getPoliklinik(String token, String pos) async {
    final response = await dio.get('getRuangan?STATUS=1&ANTRIAN=$pos', token);
    return poliklinikModelFromJson(response);
  }
}
