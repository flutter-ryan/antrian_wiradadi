import 'package:antrian_wiradadi/src/model/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/repository/dio_base_helper.dart';

class PoliklinikRepo {
  Future<PoliklinikModel> poli(String token) async {
    final res = await dio.get('getRuangan', token);

    return poliklinikModelFromJson(res);
  }
}
