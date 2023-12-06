import 'package:antrian_wiradadi/src/bloc/pendaftaran_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/db_helper.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_right_route.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/home_page.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/pendaftaran_pasien_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTiketAntrianWidget extends StatefulWidget {
  const CreateTiketAntrianWidget({
    Key? key,
    required this.token,
    required this.pendaftaranPasienBloc,
    this.jenis,
  }) : super(key: key);

  final String token;
  final PendaftaranPasienBloc pendaftaranPasienBloc;
  final String? jenis;

  @override
  State<CreateTiketAntrianWidget> createState() =>
      _CreateTiketAntrianWidgetState();
}

class _CreateTiketAntrianWidgetState extends State<CreateTiketAntrianWidget> {
  @override
  void initState() {
    super.initState();
    widget.pendaftaranPasienBloc.tokenSink.add(widget.token);
    widget.pendaftaranPasienBloc.pendaftaranPasien();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponsePendaftaranPasienModel>>(
      stream: widget.pendaftaranPasienBloc.pendaftaranPasienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return StreamResponse(
                image: 'images/loading_transparent.gif',
                message: snapshot.data!.message,
              );
            case Status.error:
              return StreamResponse(
                image: 'images/server_error_1.png',
                message: snapshot.data!.message,
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return StreamPendaftaranPasien(
                message: snapshot.data!.data!.metadata!.message!,
                jenis: widget.jenis,
                response: snapshot.data!.data!.antrian!,
              );
          }
        }
        return const Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    );
  }
}

class StreamPendaftaranPasien extends StatefulWidget {
  const StreamPendaftaranPasien({
    Key? key,
    this.message,
    this.jenis,
    required this.response,
  }) : super(key: key);

  final String? message;
  final String? jenis;
  final Antrian response;

  @override
  State<StreamPendaftaranPasien> createState() =>
      _StreamPendaftaranPasienState();
}

class _StreamPendaftaranPasienState extends State<StreamPendaftaranPasien> {
  final DbHelper _dbHelper = DbHelper();
  final DateFormat _format = DateFormat('yyyy-MM-dd HH:mm:ss');
  bool _isLoading = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _cekTiket();
  }

  Future<void> _cekTiket() async {
    bool result = await _dbHelper.selectRow(widget.response.kodebooking!);
    if (!result) {
      _saveTiket();
    } else {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
    }
  }

  Future<void> _saveTiket() async {
    AntrianSqlliteModel tiket = AntrianSqlliteModel(
      id: null,
      kodebooking: widget.response.kodebooking,
      jenispasien: widget.response.jenispasien,
      nomorkartu: widget.response.nomorkartu,
      nik: widget.response.nik,
      nohp: widget.response.nohp,
      kodepoli: widget.response.kodepoli,
      namapoli: widget.response.namapoli,
      norm: widget.response.norm.toString(),
      nama: widget.response.nama,
      tanggalperiksa: widget.response.tanggalperiksa,
      kodedokter: widget.response.kodedokter,
      namadokter: widget.response.namadokter,
      jampraktek: widget.response.jampraktek,
      jeniskunjungan: widget.response.jeniskunjungan,
      nomorreferensi: widget.response.nomorreferensi,
      nomorantreanpoli: widget.response.antreanpoli,
      estimasidilayani: widget.response.estimasidilayani,
      kodepolirs: widget.response.kodepolirs,
      keterangan: widget.response.keterangan,
      tanggaldaftar: _format.format(
        DateTime.now(),
      ),
      nomorantrean: widget.response.nomorantrean,
    );
    int? result = await _dbHelper.createTiket(tiket);
    setState(() {
      _isLoading = false;
      if (result! > 0) {
        _isSuccess = true;
      } else {
        _isSuccess = false;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("tiket", true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _isLoading
        ? const StreamResponse(
            image: 'images/loading_transparent.gif',
            message: 'Menyimpan tiket antrian',
          )
        : !_isSuccess
            ? const StreamResponse(
                image: 'images/server_error_1.png',
                message: 'Terjadi kesalahan',
              )
            : StreamResponse(
                image: 'images/success.jpg',
                message: widget.message,
                button: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        SlideRightRoute(
                          page: const Homepage(
                            tiket: true,
                          ),
                        ),
                        (_) => false),
                    style: TextButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Kembali Kehalaman Depan'),
                  ),
                ),
              );
  }
}
