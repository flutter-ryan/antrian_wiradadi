import 'package:antrian_wiradadi/src/models/rujukan_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class RujukanRepo {
  Future<RujukanModel> getRujukan(
      int faskes, String noKartu, String token) async {
    final response = await dio.get(
        'getListRujukanKartu?faskes=$faskes&noKartu=$noKartu', token);
    return rujukanModelFromJson(response);
  }
}
