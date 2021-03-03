import 'package:antrian_wiradadi/src/model/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/repository/dio_base_helper.dart';

class CaraBayarRepo {
  Future<CaraBayarModel> caraBayar(String token) async {
    final res = await dio.get('getCaraBayar', token);
    return caraBayarModelFromJson(res);
  }
}
