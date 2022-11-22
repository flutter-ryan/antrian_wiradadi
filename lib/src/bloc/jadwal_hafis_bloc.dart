import 'dart:async';

import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/repositories/jadwal_hafis_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class JadwalHafisBloc {
  final JadwalHafisRepo _repo = JadwalHafisRepo();
  StreamController<ApiResponse<JadwalDokterHafisModel>>? _streamJadwalHafis;
  final BehaviorSubject<String> _poliCon = BehaviorSubject();
  final BehaviorSubject<String> _tanggalCon = BehaviorSubject();
  final BehaviorSubject<String> _tokenCon = BehaviorSubject();

  StreamSink<String> get poliSink => _poliCon.sink;
  StreamSink<String> get tanggalSink => _tanggalCon.sink;
  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<JadwalDokterHafisModel>> get jadwalSink =>
      _streamJadwalHafis!.sink;
  Stream<ApiResponse<JadwalDokterHafisModel>> get jadwalStream =>
      _streamJadwalHafis!.stream;

  getJadwal() {
    _streamJadwalHafis = StreamController();
    final poli = _poliCon.value;
    final tanggal = _tanggalCon.value;
    final token = _tokenCon.value;
    jadwalSink.add(ApiResponse.loading("Memuat..."));
    jadwalHafis(poli, tanggal, token);
  }

  jadwalHafis(String poli, String tanggal, String token) async {
    try {
      final res = await _repo.getJadwalHafis(poli, tanggal, token);
      Future.delayed(
        const Duration(milliseconds: 500),
        () => jadwalSink.add(ApiResponse.completed(res)),
      );
    } catch (e) {
      jadwalSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamJadwalHafis?.close();
    _poliCon.close();
    _tanggalCon.close();
    _tokenCon.close();
  }
}
