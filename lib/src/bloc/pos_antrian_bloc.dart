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

  getPos() {
    _streamPosAntrian = StreamController();
    final token = _tokenCon.value;
    posAntrianSink.add(ApiResponse.loading("Memuat..."));
    posAntrian(token);
  }

  posAntrian(String token) async {
    try {
      final res = await _repo.getPos(token);
      await Future.delayed(const Duration(milliseconds: 500));
      posAntrianSink.add(ApiResponse.completed(res));
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 500));
      posAntrianSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPosAntrian?.close();
    _tokenCon.close();
  }
}
