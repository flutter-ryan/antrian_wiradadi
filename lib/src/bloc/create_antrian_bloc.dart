import 'dart:async';
import 'package:antrian_wiradadi/src/model/create_antrian_model.dart';
import 'package:antrian_wiradadi/src/repository/create_antrian_repo.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CreateAntrianBloc {
  CreateAntrianRepo _repoCreate = CreateAntrianRepo();

  StreamController _streamCreate;
  final BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _idPoliController = BehaviorSubject<String>();
  final BehaviorSubject<String> _idCaraBayarController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _normController = BehaviorSubject<String>();
  final BehaviorSubject<String> _idJenisController = BehaviorSubject<String>();
  final BehaviorSubject<String> _namaPasienController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _tanggalLahirPasienController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _nomorKontakPasienController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _tanggalKunjunganPasienController =
      BehaviorSubject<String>();

  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<String> get poli => _idPoliController.sink;
  StreamSink<String> get caraBayar => _idCaraBayarController.sink;
  StreamSink<String> get norm => _normController.sink;
  StreamSink<String> get jenis => _idJenisController.sink;
  StreamSink<String> get namaPasien => _namaPasienController.sink;
  StreamSink<String> get tanggalLahir => _tanggalLahirPasienController.sink;
  StreamSink<String> get nomorKontak => _nomorKontakPasienController.sink;
  StreamSink<String> get tanggalKunjungan =>
      _tanggalKunjunganPasienController.sink;
  StreamSink<ApiResponse<ResponseCreateAntrianModel>> get createAntrianSink =>
      _streamCreate.sink;

  Stream<String> get idPoliStream => _idPoliController.stream;
  Stream<String> get idCaraBayarStream => _idCaraBayarController.stream;
  Stream<String> get nomorRmStream => _normController.stream;
  Stream<String> get jenisStream => _idJenisController.stream;
  Stream<String> get namaStream => _namaPasienController.stream;
  Stream<String> get tanggalLahirStream => _tanggalLahirPasienController.stream;
  Stream<String> get nomorStream => _nomorKontakPasienController.stream;
  Stream<String> get tanggalKunjunganStream =>
      _tanggalKunjunganPasienController.stream;
  Stream<ApiResponse<ResponseCreateAntrianModel>> get createAntrianStream =>
      _streamCreate.stream;

  Stream<bool> get submitBaru => Rx.combineLatest([
        idPoliStream,
        idCaraBayarStream,
        jenisStream,
        namaStream,
        tanggalLahirStream,
        nomorStream,
      ], (_) => true);

  Stream<bool> get submitLama => Rx.combineLatest([
        idPoliStream,
        idCaraBayarStream,
        jenisStream,
        nomorRmStream,
        tanggalLahirStream,
        nomorStream,
        tanggalKunjunganStream
      ], (values) => true);

  createAntrian() {
    _streamCreate = StreamController<ApiResponse<ResponseCreateAntrianModel>>();
    final token = _tokenCon.value;
    final idPoli = _idPoliController.value;
    final idCaraBayar = _idCaraBayarController.value;
    final norm = _normController.value;
    final idJenis = _idJenisController.value;
    final namaPasien = _namaPasienController.value;
    final tanggalLahirPasien = _tanggalLahirPasienController.value;
    final nomorKontakPasien = _nomorKontakPasienController.value;
    final tanggalKunjunganpasien = _tanggalKunjunganPasienController.value;

    CreateAntrianModel createAntrianModel = CreateAntrianModel(
        jenis: '$idJenis',
        norm: '$norm',
        nama: '$namaPasien',
        tanggalLahir: '$tanggalLahirPasien',
        contact: '$nomorKontakPasien',
        poli: '$idPoli',
        carabayar: '$idCaraBayar',
        tanggalkunjugan: '$tanggalKunjunganpasien',
        jenisAplikasi: 1,
        status: 1);

    resultCreateAntrian(createAntrianModel, token);
  }

  resultCreateAntrian(
      CreateAntrianModel createAntrianModel, String token) async {
    createAntrianSink.add(ApiResponse.loading('Memuat...'));
    try {
      ResponseCreateAntrianModel resultCreate =
          await _repoCreate.createdAntrian(createAntrianModel, token);
      createAntrianSink.add(ApiResponse.completed(resultCreate));
    } catch (e) {
      createAntrianSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _tokenCon?.close();
    _streamCreate?.close();
    _idPoliController?.close();
    _idCaraBayarController?.close();
    _normController?.close();
    _idJenisController?.close();
    _namaPasienController?.close();
    _tanggalLahirPasienController?.close();
    _nomorKontakPasienController?.close();
    _tanggalKunjunganPasienController?.close();
  }
}
