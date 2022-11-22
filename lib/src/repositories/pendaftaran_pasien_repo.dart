import 'package:antrian_wiradadi/src/models/pendaftaran_pasien_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class PendaftaranPasienRepo {
  Future<ResponsePendaftaranPasienModel> daftarPasien(
      PendaftaranPasienModel pendaftaranPasienModel, String token) async {
    final response = await dio.post('createAntrian',
        pendaftaranPasienModelToJson(pendaftaranPasienModel), true, token);
    return responsePendaftaranPasienModelFromJson(response);
  }
}
