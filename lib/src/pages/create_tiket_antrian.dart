import 'package:antrian_wiradadi/src/blocs/pendaftaran_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/confg/db_helper_tiket.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/pendaftaran_pasien_model.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTiketAntrian extends StatefulWidget {
  const CreateTiketAntrian({
    super.key,
    required this.token,
    required this.bloc,
  });

  final String token;
  final PendaftaranPasienBloc bloc;

  @override
  State<CreateTiketAntrian> createState() => _CreateTiketAntrianState();
}

class _CreateTiketAntrianState extends State<CreateTiketAntrian> {
  late PendaftaranPasienBloc _pendaftaranPasienBloc;
  @override
  void initState() {
    super.initState();
    _pendaftaranPasienBloc = widget.bloc;
    _simpanPendaftaran();
  }

  void _simpanPendaftaran() {
    _pendaftaranPasienBloc.tokenSink.add(widget.token);
    _pendaftaranPasienBloc.pendaftaranPasien();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponsePendaftaranPasienModel>>(
      stream: _pendaftaranPasienBloc.pendaftaranPasienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(height: SizeConfig.blockSizeVertical * 35);
            case Status.error:
              return ResponseModalBottom(
                title: 'Perhatian',
                message: snapshot.data!.message,
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return ResponseModalBottom(
                  title: 'Perhatian',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return TikeAntrianWidget(
                data: snapshot.data!.data!,
                message: snapshot.data!.data!.metadata!.message,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}

class TikeAntrianWidget extends StatefulWidget {
  const TikeAntrianWidget({
    super.key,
    required this.data,
    this.message,
  });

  final ResponsePendaftaranPasienModel data;
  final String? message;

  @override
  State<TikeAntrianWidget> createState() => _TikeAntrianWidgetState();
}

class _TikeAntrianWidgetState extends State<TikeAntrianWidget> {
  final _tanggal = DateFormat('yyyy-MM-dd HH:mm:ss');
  final _dbHelperTiket = DbHelperTiket();
  bool _isLoading = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _cekTiket();
  }

  Future<void> _cekTiket() async {
    bool result =
        await _dbHelperTiket.selectRow(widget.data.antrian!.kodebooking!);
    if (!result) {
      _saveTiket();
    } else {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
    }
  }

  void _saveTiket() async {
    AntrianSqlliteModel tiket = AntrianSqlliteModel(
      id: null,
      kodebooking: widget.data.antrian!.kodebooking,
      jenispasien: 'none',
      nomorkartu: 'none',
      nik: 'none',
      nohp: 'none',
      kodepoli: 'none',
      namapoli: widget.data.antrian!.namapoli,
      norm: 'none',
      nama: widget.data.antrian!.nama,
      tanggalperiksa: widget.data.antrian!.tanggalperiksa,
      kodedokter: 'none',
      namadokter: widget.data.antrian!.namadokter,
      jampraktek: widget.data.antrian!.jampraktek,
      jeniskunjungan: 0,
      nomorreferensi: 'none',
      nomorantreanpoli: widget.data.antrian!.antreanpoli,
      estimasidilayani: widget.data.antrian!.estimasidilayani,
      kodepolirs: 'none',
      keterangan: 'none',
      tanggaldaftar: _tanggal.format(
        DateTime.now(),
      ),
      nomorantrean: widget.data.antrian!.nomorantrean,
    );
    int? result = await _dbHelperTiket.createTiket(tiket);
    setState(() {
      _isLoading = false;
      if (result! > 0) {
        _isSuccess = true;
      } else {
        _isSuccess = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingWidget(height: SizeConfig.blockSizeVertical * 35);
    }
    if (!_isSuccess) {
      return const ResponseModalBottom(
        title: 'Perhatian',
        message: 'Gagal membuat tiket antrian',
      );
    }
    return ResponseModalBottom(
      image: 'images/ask.png',
      title: widget.message,
      message: widget.data.metadata!.message,
      button: ElevatedButton(
        onPressed: () => Navigator.pop(context, 'confirm'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: kPrimaryColor.withAlpha(100),
        ),
        child: const Text('SELESAI'),
      ),
    );
  }
}
