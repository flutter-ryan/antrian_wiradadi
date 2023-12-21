import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class JadwalHafisRepo {
  Future<JadwalDokterHafisModel> getJadwalHafis(
      String? penjamin, String? tanggal, String? token) async {
    // key get POLI berubah jadi PENJAMIN
    final response = await dio.get(
        'getJadwalDokterHfis?PENJAMIN=$penjamin&TANGGAL=$tanggal', '$token');
    return jadwalDokterHafisModelFromJson(response);
  }
}
