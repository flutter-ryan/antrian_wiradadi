import 'package:antrian_wiradadi/src/model/create_antrian_model.dart';
import 'package:antrian_wiradadi/src/repository/dio_base_helper.dart';

class CreateAntrianRepo {
  Future<ResponseCreateAntrianModel> createdAntrian(
      CreateAntrianModel createAntrianModel, String token) async {
    final res = await dio.post('createAntrianWeb',
        createAntrianModelToJson(createAntrianModel), true, token);
    return responseCreateAntrianModelFromJson(res);
  }
}
