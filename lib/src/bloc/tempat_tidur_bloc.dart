import 'dart:async';

import 'package:antrian_wiradadi/src/models/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:antrian_wiradadi/src/repositories/tempat_tidur_repo.dart';
import 'package:rxdart/rxdart.dart';

class TempatTidurBloc {
  final TempatTidurRepo _repo = TempatTidurRepo();
  StreamController<ApiResponse<TempatTidurModel>>? _streamTempatTidur;

  final BehaviorSubject<String> _tokenCon = BehaviorSubject();

  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<TempatTidurModel>> get tempatTidurSink =>
      _streamTempatTidur!.sink;
  Stream<ApiResponse<TempatTidurModel>> get tempatTidurStream =>
      _streamTempatTidur!.stream;

  getTempatTidur() async {
    _streamTempatTidur = StreamController();
    final token = _tokenCon.value;
    tempatTidurSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.getTempatTidur(token);
      Future.delayed(
        const Duration(milliseconds: 500),
        () => tempatTidurSink.add(ApiResponse.completed(res)),
      );
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => tempatTidurSink.add(ApiResponse.error(e.toString())),
      );
    }
  }

  dispose() {
    _streamTempatTidur?.close();
    _tokenCon.close();
  }
}
