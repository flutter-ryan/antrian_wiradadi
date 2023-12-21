import 'dart:async';

import 'package:antrian_wiradadi/src/blocs/input_validation.dart';
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
  final BehaviorSubject<String> _noKartuCon = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _noRefCon = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _normCon = BehaviorSubject.seeded('');
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
  Stream<ApiResponse<ResponsePendaftaranPasienModel>>
      get pendaftaranPasienStream => _streamPendaftaran!.stream;

  Future<void> pendaftaranPasien() async {
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
    pendaftaranPasienSink.add(ApiResponse.loading(
        "Membuat Tiket Antrian...\nHarap untuk menunggu sesaat"));
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
      jenisAplikasi: 22,
      status: 1,
    );

    print(
        'jenis: $jenis, nama: $nama, noKartu: $noKartuBpjs, rujuakan: $noRefBpjs, norm: $norm, nik: $nik, tl: $tanggalLahir, hp: $contact, poli: $poli, poliBpjs: $poliBpjs, cara: $carabayar, kdDokter $dokter, tanggal: $tanggalkunjungan, jamPraktek: $jamPraktek');

    try {
      final resp = await _repo.daftarPasien(pendaftaranPasienModel, token);
      if (_streamPendaftaran!.isClosed) return;
      pendaftaranPasienSink.add(ApiResponse.completed(resp));
    } catch (e) {
      if (_streamPendaftaran!.isClosed) return;
      pendaftaranPasienSink.add(ApiResponse.error(e.toString()));
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
