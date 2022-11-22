import 'package:antrian_wiradadi/src/models/pos_antrian_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class PosAntrianRepo {
  Future<PosAntrianModel> getPos(String token) async {
    final response = await dio.get('getPosAntrian', token);
    return posAntrianModelFromJson(response);
  }
}
