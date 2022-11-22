import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class CariPasienRepo {
  Future<ResponseCariPasienModel> cariPasien(
      CariPasienModel cariPasienModel, String token) async {
    final res = await dio.post('getIdentitasPasien',
        cariPasienModelToJson(cariPasienModel), true, token);
    return responseCariPasienModelFromJson(res);
  }
}
