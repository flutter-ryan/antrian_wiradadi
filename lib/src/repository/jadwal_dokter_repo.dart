import 'package:antrian_wiradadi/src/model/jadwal_dokter_model.dart';
import 'package:antrian_wiradadi/src/repository/dio_base_helper.dart';

class JadwalDokterRepo {
  Future<JadwalDokterModel> getJadwal(String token, String id) async {
    final response =
        await dio.get('getJadwalDokter?RUANGAN=$id&SORT=true&STATUS=1', token);

    return jadwalDokterModelFromJson(response);
  }
}
