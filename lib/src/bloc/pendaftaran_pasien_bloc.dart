import 'dart:async';

import 'package:antrian_wiradadi/src/bloc/validation/input_validation.dart';
import 'package:antrian_wiradadi/src/models/pendaftaran_pasien_model.dart';
import 'package:antrian_wiradadi/src/repositories/pendaftaran_pasien_repo.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PendaftaranPasienBloc extends Object with InputValidation {
  final PendaftaranPasienRepo _repo = PendaftaranPasienRepo();
  StreamController<ApiResponse<ResponsePendaftaranPasienModel>>?
      _streamPendaftaran;

  final BehaviorSubject<String> _tokenCon = BehaviorSubject();
  final BehaviorSubject<String> _jenisCon = BehaviorSubject();
  final BehaviorSubject<String> _namaCon = BehaviorSubject();
  final BehaviorSubject<String> _noKartuCon = BehaviorSubject();
  final BehaviorSubject<String> _noRefCon = BehaviorSubject();
  final BehaviorSubject<String> _normCon = BehaviorSubject();
  final BehaviorSubject<String> _nikCon = BehaviorSubject();
  final BehaviorSubject<String> _tanggalLahirCon = BehaviorSubject();
  final BehaviorSubject<String> _contactCon = BehaviorSubject();
  final BehaviorSubject<String> _poliCon = BehaviorSubject();
  final BehaviorSubject<String> _poliBpjsCon = BehaviorSubject();
  final BehaviorSubject<String> _caraBayarCon = BehaviorSubject();
  final BehaviorSubject<String> _dokterCon = BehaviorSubject();
  final BehaviorSubject<String> _tanggalKunjunganCon = BehaviorSubject();
  final BehaviorSubject<String> _jamPraktekCon = BehaviorSubject();

  StreamSink<String> get tokenSink => _tokenCon.sink;
  StreamSink<String> get jenisSink => _jenisCon.sink;
  StreamSink<String> get namaSink => _namaCon.sink;
  StreamSink<String> get noKartuSink => _noKartuCon.sink;
  StreamSink<String> get noRefSink => _noRefCon.sink;
  StreamSink<String> get normSink => _normCon.sink;
  StreamSink<String> get nikSink => _nikCon.sink;
  StreamSink<String> get tanggalLahirSink => _tanggalLahirCon.sink;
  StreamSink<String> get contactSink => _contactCon.sink;
  StreamSink<String> get poliSink => _poliCon.sink;
  StreamSink<String> get poliBpjsSink => _poliBpjsCon.sink;
  StreamSink<String> get caraBayarSink => _caraBayarCon.sink;
  StreamSink<String> get dokterSink => _dokterCon.sink;
  StreamSink<String> get tanggalKunjunganSink => _tanggalKunjunganCon.sink;
  StreamSink<String> get jamPraktekSink => _jamPraktekCon.sink;
  StreamSink<ApiResponse<ResponsePendaftaranPasienModel>>
      get pendaftaranPasienSink => _streamPendaftaran!.sink;

  Stream<String> get jenisStream => _jenisCon.stream.transform(emptyValidate);
  Stream<String> get namaStream => _namaCon.stream.transform(emptyValidate);
  Stream<String> get noKartuStream =>
      _noKartuCon.stream.transform(karakterBpjsValidate);
  Stream<String> get noRefStream =>
      _noRefCon.stream.transform(karakterNoRujukanValidate);
  Stream<String> get normStream => _normCon.stream.transform(emptyValidate);
  Stream<String> get nikStream => _nikCon.stream.transform(karakterValidate);
  Stream<String> get tanggalLahirstream =>
      _tanggalLahirCon.stream.transform(emptyValidate);
  Stream<String> get contactStream =>
      _contactCon.stream.transform(emptyValidate);
  Stream<String> get poliStream => _poliCon.stream.transform(emptyValidate);
  Stream<String> get poliBpjsStream =>
      _poliBpjsCon.stream.transform(emptyValidate);
  Stream<String> get caraBayarStream =>
      _caraBayarCon.stream.transform(emptyValidate);
  Stream<String> get dokterStream => _dokterCon.stream.transform(emptyValidate);
  Stream<String> get tanggalKunjunganStream =>
      _tanggalKunjunganCon.stream.transform(emptyValidate);
  Stream<String> get jamPraktekStream =>
      _jamPraktekCon.stream.transform(emptyValidate);
  Stream<ApiResponse<ResponsePendaftaranPasienModel>>
      get pendaftaranPasienStream => _streamPendaftaran!.stream;

  Stream<bool> get submitBaru => Rx.combineLatest([
        nikStream,
        namaStream,
        tanggalLahirstream,
        contactStream,
        caraBayarStream,
        poliStream,
        poliBpjsStream,
        tanggalKunjunganStream,
        dokterStream,
        jamPraktekStream,
      ], (_) => true).asBroadcastStream();
  Stream<bool> get submitBaruKartu => Rx.combineLatest([
        nikStream,
        namaStream,
        tanggalLahirstream,
        contactStream,
        caraBayarStream,
        poliStream,
        tanggalKunjunganStream,
        dokterStream,
        jamPraktekStream,
        noKartuStream,
        noRefStream,
      ], (_) => true).asBroadcastStream();
  Stream<bool> get submitLama => Rx.combineLatest([
        nikStream,
        normStream,
        namaStream,
        tanggalLahirstream,
        contactStream,
        caraBayarStream,
        poliStream,
        tanggalKunjunganStream,
        noKartuStream,
        noRefStream,
        dokterStream,
        jamPraktekStream,
      ], (_) => true).asBroadcastStream();
  Stream<bool> get submitLamaKartu => Rx.combineLatest([
        nikStream,
        normStream,
        namaStream,
        tanggalLahirstream,
        contactStream,
        caraBayarStream,
        poliStream,
        tanggalKunjunganStream,
        noKartuStream,
        noRefStream,
        dokterStream,
        jamPraktekStream,
        noKartuStream,
        noRefStream,
      ], (_) => true).asBroadcastStream();

  pendaftaranPasien() {
    _streamPendaftaran = StreamController();
    final token = _tokenCon.value;
    final poli = _poliCon.value;
    final carabayar = _caraBayarCon.value;
    final norm = _normCon.value;
    final nik = _nikCon.value;
    final jenis = _jenisCon.value;
    final nama = _namaCon.value;
    final tanggalLahir = _tanggalLahirCon.value;
    final contact = _contactCon.value;
    final tanggalkunjungan = _tanggalKunjunganCon.value;
    final noKartuBpjs = _noKartuCon.value;
    final noRefBpjs = _noRefCon.value;
    final poliBpjs = _poliBpjsCon.value;
    final dokter = _dokterCon.value;
    final jamPraktek = _jamPraktekCon.value;

    PendaftaranPasienModel pendaftaranPasienModel = PendaftaranPasienModel(
      jenis: jenis,
      nama: nama,
      noKartuBpjs: noKartuBpjs,
      noRefBpjs: noRefBpjs,
      norm: norm,
      nik: nik,
      tanggalLahir: tanggalLahir,
      contact: contact,
      poli: poli,
      poliBpjs: poliBpjs,
      carabayar: carabayar,
      dokter: dokter,
      tanggalkunjungan: tanggalkunjungan,
      jamPraktek: jamPraktek,
      jenisAplikasi: 1,
      status: 1,
    );
    print(
        '$jenis, $nama, $noKartuBpjs, $noRefBpjs, $norm, $nik, $tanggalLahir, $contact, $poli, $poliBpjs, $carabayar, $dokter, $tanggalkunjungan, $jamPraktek');

    resultCreateAntrian(pendaftaranPasienModel, token);
  }

  resultCreateAntrian(
      PendaftaranPasienModel pendaftaranPasienModel, token) async {
    pendaftaranPasienSink.add(ApiResponse.loading(
        "Membuat Tiket Antrian...\nHarap untuk menunggu sesaat"));
    try {
      final resp = await _repo.daftarPasien(pendaftaranPasienModel, token);
      Future.delayed(
        const Duration(milliseconds: 600),
        () => pendaftaranPasienSink.add(
          ApiResponse.completed(resp),
        ),
      );
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 600),
        () => pendaftaranPasienSink.add(ApiResponse.error(e.toString())),
      );
    }
  }

  dispose() {
    _streamPendaftaran?.close();
    _tokenCon.close();
    _poliCon.close();
    _caraBayarCon.close();
    _noKartuCon.close();
    _normCon.close();
    _jenisCon.close();
    _namaCon.close();
    _tanggalLahirCon.close();
    _contactCon.close();
    _tanggalKunjunganCon.close();
    _dokterCon.close();
    _noKartuCon.close();
    _noRefCon.close();
    _jamPraktekCon.close();
    _nikCon.close();
    _poliBpjsCon.close();
  }
}
