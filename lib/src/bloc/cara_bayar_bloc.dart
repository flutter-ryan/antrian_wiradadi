import 'dart:async';

import 'package:antrian_wiradadi/src/models/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/repositories/cara_bayar_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CaraBayarBloc {
  final CaraBayarRepo _repo = CaraBayarRepo();
  StreamController<ApiResponse<CaraBayarModel>>? _streamCara;

  final BehaviorSubject<String?> _tokenCon = BehaviorSubject<String>();
  StreamSink<String?> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<CaraBayarModel>> get caraBayarSink =>
      _streamCara!.sink;
  Stream<ApiResponse<CaraBayarModel>> get caraBayarStream =>
      _streamCara!.stream;

  getCaraBayar() {
    _streamCara = StreamController();
    final token = _tokenCon.value;
    fetchCaraBayar(token);
  }

  fetchCaraBayar(String? token) async {
    caraBayarSink.add(ApiResponse.loading('Memuat...'));
    try {
      CaraBayarModel caraModel = await _repo.caraBayar(token);
      Future.delayed(
        const Duration(milliseconds: 600),
        () => caraBayarSink.add(
          ApiResponse.completed(caraModel),
        ),
      );
    } catch (e) {
      caraBayarSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _tokenCon.close();
    _streamCara?.close();
  }
}
