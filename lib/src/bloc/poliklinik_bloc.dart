import 'dart:async';

import 'package:antrian_wiradadi/src/model/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/repository/poliklinik_repo.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PoliklinikBloc {
  PoliklinikRepo _repo = PoliklinikRepo();
  StreamController _streamPoli;

  BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<PoliklinikModel>> get poliSink => _streamPoli.sink;
  Stream<ApiResponse<PoliklinikModel>> get poliStream => _streamPoli.stream;

  getPoli() {
    _streamPoli = StreamController<ApiResponse<PoliklinikModel>>();
    final token = _tokenCon.value;
    fetchPoli(token);
  }

  fetchPoli(String token) async {
    poliSink.add(ApiResponse.loading('Memuat...'));
    try {
      PoliklinikModel poliModel = await _repo.poli(token);
      Future.delayed(
        Duration(seconds: 2),
        () => poliSink.add(ApiResponse.completed(poliModel)),
      );
    } catch (e) {
      Future.delayed(
        Duration(milliseconds: 1000),
        () => poliSink.add(
          ApiResponse.error(e.toString()),
        ),
      );
    }
  }

  dispose() {
    _tokenCon?.close();
    _streamPoli?.close();
  }
}
