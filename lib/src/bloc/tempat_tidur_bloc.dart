import 'dart:async';

import 'package:antrian_wiradadi/src/model/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:antrian_wiradadi/src/repository/tempat_tidur_repo.dart';
import 'package:rxdart/rxdart.dart';

class TempatTidurBloc {
  TempatTidurRepo _repo = TempatTidurRepo();
  StreamController _streamTempatTidur;

  BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<TempatTidurModel>> get tempatTidurSink =>
      _streamTempatTidur.sink;
  Stream<ApiResponse<TempatTidurModel>> get tempatTidurStream =>
      _streamTempatTidur.stream;

  getTt() async {
    _streamTempatTidur = StreamController<ApiResponse<TempatTidurModel>>();
    final token = _tokenCon.value;
    tempatTidurSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.getTempatTidur(token);

      tempatTidurSink.add(ApiResponse.completed(res));
    } catch (e) {
      tempatTidurSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _tokenCon?.close();
    _streamTempatTidur?.close();
  }
}
