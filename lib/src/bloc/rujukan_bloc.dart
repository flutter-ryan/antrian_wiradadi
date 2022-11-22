import 'dart:async';

import 'package:antrian_wiradadi/src/models/rujukan_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:antrian_wiradadi/src/repositories/rujukan_repo.dart';
import 'package:rxdart/rxdart.dart';

class RujukanBloc {
  final _repo = RujukanRepo();
  StreamController<ApiResponse<RujukanModel>>? _streamRujukan;
  final BehaviorSubject<String> _token = BehaviorSubject();
  final BehaviorSubject<int> _faskes = BehaviorSubject();
  final BehaviorSubject<String> _noKartu = BehaviorSubject();
  StreamSink<String> get tokenSink => _token.sink;
  StreamSink<int> get faskesSink => _faskes.sink;
  StreamSink<String> get noKartuSink => _noKartu.sink;
  StreamSink<ApiResponse<RujukanModel>> get rujukanSink => _streamRujukan!.sink;
  Stream<ApiResponse<RujukanModel>> get rujukanStream => _streamRujukan!.stream;

  Future<void> getRujukan() async {
    _streamRujukan = StreamController();
    final token = _token.value;
    final faskes = _faskes.value;
    final noKartu = _noKartu.value;
    rujukanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getRujukan(faskes, noKartu, token);
      if (_streamRujukan!.isClosed) return;
      rujukanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamRujukan!.isClosed) return;
      rujukanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _token.close();
    _faskes.close();
    _noKartu.close();
    _streamRujukan?.close();
  }
}
