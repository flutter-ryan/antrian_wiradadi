import 'dart:async';

import 'package:antrian_wiradadi/src/model/jadwal_dokter_model.dart';
import 'package:antrian_wiradadi/src/repository/jadwal_dokter_repo.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class JadwalDokterBloc {
  JadwalDokterRepo _repo = JadwalDokterRepo();
  StreamController _streamJadwal;

  BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  BehaviorSubject<String> _idPoliCon = BehaviorSubject<String>();

  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<String> get idPoliSink => _idPoliCon.sink;
  StreamSink<ApiResponse<JadwalDokterModel>> get jadwalSink =>
      _streamJadwal.sink;
  Stream<ApiResponse<JadwalDokterModel>> get jadwalStream =>
      _streamJadwal.stream;

  getJadwal() {
    _streamJadwal = StreamController<ApiResponse<JadwalDokterModel>>();
    final token = _tokenCon.value;
    final idJadwal = _idPoliCon.value;

    getJadwalNow(token, idJadwal);
  }

  getJadwalNow(String token, String idPoli) async {
    jadwalSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.getJadwal(token, idPoli);
      Future.delayed(
        Duration(seconds: 2),
        () => jadwalSink.add(ApiResponse.completed(res)),
      );
    } catch (e) {
      Future.delayed(
        Duration(milliseconds: 500),
        () => jadwalSink.add(ApiResponse.error(e.toString())),
      );
    }
  }

  dispose() {
    _streamJadwal?.close();
    _tokenCon.close();
    _idPoliCon.close();
  }
}
