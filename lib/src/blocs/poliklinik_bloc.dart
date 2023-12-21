import 'dart:async';

import 'package:antrian_wiradadi/src/models/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/repositories/poliklinik_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PoliklinikBloc {
  final PoliklinikRepo _repo = PoliklinikRepo();
  StreamController<ApiResponse<PoliklinikModel>>? _streamPoli;

  final BehaviorSubject<String> _tokenCon = BehaviorSubject();
  final BehaviorSubject<String> _posCon = BehaviorSubject();

  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<String> get posSink => _posCon.sink;
  StreamSink<ApiResponse<PoliklinikModel>> get poliSink => _streamPoli!.sink;
  Stream<ApiResponse<PoliklinikModel>> get poliStream => _streamPoli!.stream;

  Future<void> getPoli() async {
    _streamPoli = StreamController();
    poliSink.add(ApiResponse.loading('Memuat...'));
    final token = _tokenCon.value;
    final pos = _posCon.value;
    try {
      PoliklinikModel poliModel = await _repo.getPoliklinik(token, pos);
      if (_streamPoli!.isClosed) return;
      poliSink.add(ApiResponse.completed(poliModel));
    } catch (e) {
      if (_streamPoli!.isClosed) return;
      poliSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _tokenCon.close();
    _posCon.close();
    _streamPoli?.close();
  }
}
