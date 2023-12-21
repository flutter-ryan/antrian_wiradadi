import 'dart:async';

import 'package:antrian_wiradadi/src/models/pos_antrian_model.dart';
import 'package:antrian_wiradadi/src/repositories/pos_antrian_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PosAntrianBloc {
  final PosAntrianRepo _repo = PosAntrianRepo();
  StreamController<ApiResponse<PosAntrianModel>>? _streamPosAntrian;

  final BehaviorSubject<String> _tokenCon = BehaviorSubject();
  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<PosAntrianModel>> get posAntrianSink =>
      _streamPosAntrian!.sink;
  Stream<ApiResponse<PosAntrianModel>> get posAntrianStream =>
      _streamPosAntrian!.stream;

  Future<void> getPos() async {
    _streamPosAntrian = StreamController();
    posAntrianSink.add(ApiResponse.loading("Memuat pos antrian..."));
    final token = _tokenCon.value;
    try {
      final res = await _repo.getPos(token);
      if (_streamPosAntrian!.isClosed) return;
      posAntrianSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPosAntrian!.isClosed) return;
      posAntrianSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPosAntrian?.close();
    _tokenCon.close();
  }
}
