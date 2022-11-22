import 'package:antrian_wiradadi/src/models/cari_nik_pasien_model.dart';
import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class CariNikPasienRepo {
  Future<ResponseCariPasienModel> cariNikPasien(
      CariNikPasienModel cariNikPasienModel, token) async {
    final res = await dio.post('getIdentitasPasien',
        cariNikPasienModelToJson(cariNikPasienModel), true, token);
    return responseCariPasienModelFromJson(res);
  }
}
