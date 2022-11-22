import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class JadwalHafisRepo {
  Future<JadwalDokterHafisModel> getJadwalHafis(
      String? poli, String? tanggal, String token) async {
    final response =
        await dio.get('getJadwalDokterHfis?POLI=$poli&TANGGAL=$tanggal', token);
    return jadwalDokterHafisModelFromJson(response);
  }
}
