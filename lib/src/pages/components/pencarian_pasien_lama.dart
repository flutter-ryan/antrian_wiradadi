import 'package:antrian_wiradadi/src/blocs/cari_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/db_helper_identitas.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/date_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/identitas_pasien.dart';
import 'package:antrian_wiradadi/src/pages/components/input_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class PencarianPasienLama extends StatefulWidget {
  const PencarianPasienLama({
    super.key,
    required this.jenis,
    required this.dbHelper,
  });

  final int jenis;
  final DbHelperIdentitas dbHelper;

  @override
  State<PencarianPasienLama> createState() => _PencarianPasienLamaState();
}

class _PencarianPasienLamaState extends State<PencarianPasienLama> {
  final _tokenBloc = TokenBloc();
  final _norm = TextEditingController();
  final _normFocus = FocusNode();
  final _tanggal = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _cari = false;

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(_normFocus);
    });
  }

  void _cariPasien() {
    if (validateAndSave()) {
      _tokenBloc.getToken();
      setState(() {
        _cari = true;
      });
    }
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cari) {
      return _streamToken(context);
    }
    return Form(
      key: _formKey,
      child: Container(
        constraints:
            BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(22.0),
              child: Text(
                'Pencarian Pasien',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(
              height: 0.0,
            ),
            const SizedBox(
              height: 18.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
              child: InputFormField(
                controller: _norm,
                focusNode: _normFocus,
                label: 'Norm/NIK',
                hint: 'Ketikkan nomor rm/nomor identitas',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
              child: DateFormField(
                controller: _tanggal,
                label: 'Tanggal lahir',
                hint: 'Ketikkan tanggal lahir sesuai identitas',
                icon: const Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
              child: ElevatedButton(
                onPressed: _cariPasien,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: kPrimaryColor,
                ),
                child: const Text('Cari Pasien'),
              ),
            ),
            const SizedBox(
              height: 32.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _streamToken(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(height: SizeConfig.blockSizeVertical * 30);
            case Status.error:
              return ResponseModalBottom(
                image: 'images/sorry.png',
                message: snapshot.data!.message,
                title: 'Terjadi kesalahan',
                button: ElevatedButton(
                  onPressed: () => setState(() {
                    _cari = false;
                  }),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return ResponseModalBottom(
                  image: 'images/sorry.png',
                  message: '${snapshot.data!.data!.metadata!.message}',
                  title: 'Terjadi kesalahan',
                  button: ElevatedButton(
                    onPressed: () => setState(() {
                      _cari = false;
                    }),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: kPrimaryColor,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                );
              }
              return HasilPencarianPasien(
                token: snapshot.data!.data!.response!.token!,
                jenis: widget.jenis,
                dbHelper: widget.dbHelper,
                norm: _norm.text,
                tanggal: _tanggal.text,
                reload: () => setState(() {
                  _cari = false;
                }),
              );
          }
        }
        return SizedBox(height: SizeConfig.blockSizeVertical * 30);
      },
    );
  }
}

class HasilPencarianPasien extends StatefulWidget {
  const HasilPencarianPasien({
    super.key,
    required this.token,
    required this.jenis,
    required this.dbHelper,
    required this.norm,
    required this.tanggal,
    this.reload,
  });
  final int jenis;
  final String token;
  final DbHelperIdentitas dbHelper;
  final String norm;
  final String tanggal;
  final VoidCallback? reload;

  @override
  State<HasilPencarianPasien> createState() => _HasilPencarianPasienState();
}

class _HasilPencarianPasienState extends State<HasilPencarianPasien> {
  final _cariPasienBloc = CariPasienBloc();

  @override
  void initState() {
    super.initState();
    _cariPasienBloc.tokenSink.add(widget.token);
    _cariPasienBloc.noRm.add(widget.norm);
    _cariPasienBloc.tanggalLahir.add(widget.tanggal);
    _cariPasienBloc.cariPasien();
  }

  @override
  void dispose() {
    _cariPasienBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseCariPasienModel>>(
      stream: _cariPasienBloc.cariPasienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(height: SizeConfig.blockSizeVertical * 30);
            case Status.error:
              return ResponseModalBottom(
                image: 'images/sorry.png',
                message: snapshot.data!.message,
                title: 'Terjadi kesalahan',
              );
            case Status.completed:
              if (!snapshot.data!.data!.success) {
                return ResponseModalBottom(
                  image: 'images/sorry.png',
                  message:
                      'Data pasien tidak ditemukan, Pastikan norm dan tanggal lahir sudah sesuai',
                  title: 'Terjadi kesalahan',
                  button: ElevatedButton(
                    onPressed: widget.reload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text('Coba lagi'),
                  ),
                );
              }
              var data = snapshot.data!.data!.pasien;
              return FormIdentitasPasien(
                jenis: widget.jenis,
                dbHelper: widget.dbHelper,
                pasien: data!.first,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 30,
        );
      },
    );
  }
}
