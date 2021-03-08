import 'dart:async';

import 'package:antrian_wiradadi/src/bloc/validation/input_validation.dart';
import 'package:antrian_wiradadi/src/model/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/repository/cari_pasien_repo.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CariPasienBloc extends Object with InputValidation {
  CariPasienRepo _repoCari = CariPasienRepo();
  StreamController _streamCari;

  final BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _normController = BehaviorSubject<String>();
  final BehaviorSubject<String> _tanggalLahirController =
      BehaviorSubject<String>();
  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<String> get noRm => _normController.sink;
  StreamSink<String> get tanggalLahir => _tanggalLahirController.sink;
  StreamSink<ApiResponse<ResponseCariPasienModel>> get cariPasienSink =>
      _streamCari.sink;

  Stream<String> get noRmStream =>
      _normController.stream.transform(noRmValidate);
  Stream<String> get tanggalLahirStream =>
      _tanggalLahirController.stream.transform(tanggalLahirValidate);
  Stream<ApiResponse<ResponseCariPasienModel>> get cariPasienStream =>
      _streamCari.stream;

  Stream<bool> get submitStream =>
      Rx.combineLatest([noRmStream, tanggalLahirStream], (_) => true);

  cariPasien() {
    _streamCari = StreamController<ApiResponse<ResponseCariPasienModel>>();
    final norm = _normController.value;
    final tanggal = _tanggalLahirController.value;
    final token = _tokenCon.value;

    CariPasienModel cariPasienModel =
        CariPasienModel(norm: '$norm', tanggalLahir: '$tanggal');

    fetchCariPasien(cariPasienModel, token);
  }

  fetchCariPasien(CariPasienModel cariModel, String token) async {
    cariPasienSink.add(ApiResponse.loading('Memuat...'));
    try {
      ResponseCariPasienModel responseCari =
          await _repoCari.cariPasien(cariModel, token);
      Future.delayed(Duration(milliseconds: 1000), () {
        cariPasienSink.add(ApiResponse.completed(responseCari));
      });
    } catch (e) {
      Future.delayed(Duration(milliseconds: 1000), () {
        cariPasienSink.add(ApiResponse.error(e.toString()));
      });
    }
  }

  dispose() {
    _tokenCon?.close();
    _normController?.close();
    _tanggalLahirController?.close();
    _streamCari?.close();
  }
}
