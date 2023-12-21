import 'dart:async';

import 'package:antrian_wiradadi/src/blocs/input_validation.dart';
import 'package:antrian_wiradadi/src/models/cari_nik_pasien_model.dart';
import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/repositories/cari_nik_pasien_repo.dart';
import 'package:antrian_wiradadi/src/repositories/cari_pasien_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CariPasienBloc extends Object with InputValidation {
  final CariPasienRepo _repoCari = CariPasienRepo();
  final CariNikPasienRepo _repoNikCari = CariNikPasienRepo();
  StreamController<ApiResponse<ResponseCariPasienModel>>? _streamCari;

  final BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _normController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nikCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _tanggalLahirController =
      BehaviorSubject<String>();

  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<String> get noRm => _normController.sink;
  StreamSink<String> get tanggalLahir => _tanggalLahirController.sink;
  StreamSink<String> get nikSink => _nikCon.sink;
  StreamSink<ApiResponse<ResponseCariPasienModel>> get cariPasienSink =>
      _streamCari!.sink;

  Stream<String> get noRmStream =>
      _normController.stream.transform(emptyValidate);
  Stream<String> get tanggalLahirStream =>
      _tanggalLahirController.stream.transform(emptyValidate);
  Stream<ApiResponse<ResponseCariPasienModel>> get cariPasienStream =>
      _streamCari!.stream;
  Stream<bool> get submitCari =>
      Rx.combineLatest([noRmStream, tanggalLahirStream], (_) => true);

  void cariPasien() {
    _streamCari = StreamController();
    final norm = _normController.value;
    final tanggal = _tanggalLahirController.value;
    final token = _tokenCon.value;

    if (norm.length == 16) {
      CariNikPasienModel cariNikPasienModel =
          CariNikPasienModel(nik: norm, tanggalLahir: tanggal);
      fetchCariNikPasien(cariNikPasienModel, token);
    } else {
      CariPasienModel cariPasienModel =
          CariPasienModel(norm: norm, tanggalLahir: tanggal);
      fetchCariPasien(cariPasienModel, token);
    }
  }

  fetchCariPasien(CariPasienModel cariModel, String token) async {
    cariPasienSink.add(ApiResponse.loading('Mencari Pasien...'));
    try {
      ResponseCariPasienModel responseCari =
          await _repoCari.cariPasien(cariModel, token);
      Future.delayed(const Duration(milliseconds: 500), () {
        cariPasienSink.add(ApiResponse.completed(responseCari));
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 500), () {
        cariPasienSink.add(ApiResponse.error(e.toString()));
      });
    }
  }

  fetchCariNikPasien(CariNikPasienModel cariNikPasienModel, token) async {
    cariPasienSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoNikCari.cariNikPasien(cariNikPasienModel, token);
      Future.delayed(const Duration(milliseconds: 500), () {
        cariPasienSink.add(ApiResponse.completed(res));
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 500), () {
        cariPasienSink.add(ApiResponse.error(e.toString()));
      });
    }
  }

  dispose() {
    _tokenCon.close();
    _normController.close();
    _tanggalLahirController.close();
    _nikCon.close();
    _streamCari?.close();
  }
}
