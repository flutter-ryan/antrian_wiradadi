import 'dart:async';

import 'package:antrian_wiradadi/src/model/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/repository/cara_bayar_repo.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CaraBayarBloc {
  CaraBayarRepo _repo = CaraBayarRepo();
  StreamController _streamCara;

  BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<ApiResponse<CaraBayarModel>> get caraBayarSink => _streamCara.sink;
  Stream<ApiResponse<CaraBayarModel>> get caraBayarStream => _streamCara.stream;

  getCaraBayar() {
    _streamCara = StreamController<ApiResponse<CaraBayarModel>>();
    final token = _tokenCon.value;
    fetchCaraBayar(token);
  }

  fetchCaraBayar(String token) async {
    caraBayarSink.add(ApiResponse.loading('Memuat...'));
    try {
      CaraBayarModel caraModel = await _repo.caraBayar(token);
      Future.delayed(Duration(milliseconds: 1000), () {
        caraBayarSink.add(ApiResponse.completed(caraModel));
      });
    } catch (e) {
      Future.delayed(Duration(milliseconds: 1000), () {
        caraBayarSink.add(ApiResponse.error(e.toString()));
      });
    }
  }

  dispose() {
    _tokenCon?.close();
    _streamCara?.close();
  }
}
