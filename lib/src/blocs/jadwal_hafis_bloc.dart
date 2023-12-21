import 'dart:async';

import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/repositories/jadwal_hafis_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class JadwalHafisBloc {
  final JadwalHafisRepo _repo = JadwalHafisRepo();
  StreamController<ApiResponse<JadwalDokterHafisModel>>? _streamJadwalHafis;
  final BehaviorSubject<String?> _tanggalCon = BehaviorSubject();
  final BehaviorSubject<String?> _tokenCon = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> _penjamin = BehaviorSubject.seeded('');

  StreamSink<String?> get tanggalSink => _tanggalCon.sink;
  StreamSink<String?> get tokenSink => _tokenCon.sink;
  StreamSink<String?> get penjaminSink => _penjamin.sink;
  StreamSink<ApiResponse<JadwalDokterHafisModel>> get jadwalSink =>
      _streamJadwalHafis!.sink;
  Stream<ApiResponse<JadwalDokterHafisModel>> get jadwalStream =>
      _streamJadwalHafis!.stream;

  Future<void> getJadwal() async {
    _streamJadwalHafis = StreamController();
    jadwalSink.add(ApiResponse.loading("Memuat..."));
    // poli diubah menjadi penjamin
    final tanggal = _tanggalCon.value;
    final token = _tokenCon.value;
    final penjamin = _penjamin.value;
    try {
      final res = await _repo.getJadwalHafis(penjamin, tanggal, token);
      if (_streamJadwalHafis!.isClosed) return;
      jadwalSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamJadwalHafis!.isClosed) return;
      jadwalSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamJadwalHafis?.close();
    _tanggalCon.close();
    _tokenCon.close();
  }
}
