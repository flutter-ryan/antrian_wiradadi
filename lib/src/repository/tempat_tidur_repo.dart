import 'package:antrian_wiradadi/src/model/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/repository/dio_base_helper.dart';

class TempatTidurRepo {
  Future<TempatTidurModel> getTempatTidur(String token) async {
    final response = await dio.get('getKetersediaanTempatTidur', token);

    return tempatTidurModelFromJson(response);
  }
}
