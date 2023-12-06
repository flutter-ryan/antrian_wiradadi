import 'package:antrian_wiradadi/src/bloc/cari_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/input_text.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/input_text_date.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPencarianPasien extends StatefulWidget {
  const FormPencarianPasien({Key? key}) : super(key: key);

  @override
  State<FormPencarianPasien> createState() => _FormPencarianPasienState();
}

class _FormPencarianPasienState extends State<FormPencarianPasien> {
  final CariPasienBloc _cariPasienBloc = CariPasienBloc();
  final TokenBloc _tokenBloc = TokenBloc();
  bool _streamState = false;

  void _cariPasien() {
    _tokenBloc.getToken();
    setState(() {
      _streamState = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: _streamState
          ? _buildStreamToken(context)
          : PencarianPasienForm(
              cariPasienBloc: _cariPasienBloc,
              cariPasien: _cariPasien,
            ),
    );
  }

  Widget _buildStreamToken(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
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
              if (snapshot.data!.data!.metadata!.code == 500) {
                return StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return ResultPencarianPasien(
                cariPasienBloc: _cariPasienBloc,
                token: snapshot.data!.data!.response!.token!,
                retry: () {
                  setState(
                    () => _streamState = false,
                  );
                },
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

class PencarianPasienForm extends StatefulWidget {
  const PencarianPasienForm({
    Key? key,
    required this.cariPasien,
    required this.cariPasienBloc,
  }) : super(key: key);

  final Function() cariPasien;
  final CariPasienBloc cariPasienBloc;

  @override
  State<PencarianPasienForm> createState() => _PencarianPasienFormState();
}

class _PencarianPasienFormState extends State<PencarianPasienForm> {
  final TextEditingController _nomorRmCon = TextEditingController();
  final TextEditingController _tanggalLahirCon = TextEditingController();
  final FocusNode _nomorRmFocus = FocusNode();
  final FocusNode _tanggalLahirFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.cariPasienBloc.noRm.add('');
    widget.cariPasienBloc.tanggalLahir.add('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(22.0, 12.0, 8.0, 12.0),
          decoration: const BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pencarian pasien',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 22.0,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              InputText(
                label: 'Norm/NIK',
                hint: 'Input Nomor RM atau NIK',
                textCon: _nomorRmCon,
                textFocus: _nomorRmFocus,
                focus: true,
                isNik: true,
                keyType: TextInputType.number,
                sink: widget.cariPasienBloc.noRm,
                stream: widget.cariPasienBloc.noRmStream,
              ),
              const SizedBox(
                height: 18.0,
              ),
              InputTextDate(
                label: 'Tanggal lahir',
                hint: 'Tanggal lahir sesuai identitas',
                textCon: _tanggalLahirCon,
                textFocus: _tanggalLahirFocus,
                nextFocus: FocusNode(),
                jenis: 'lahir',
                stream: widget.cariPasienBloc.tanggalLahirStream,
                sink: widget.cariPasienBloc.tanggalLahir,
                getDate: (String? date) {},
              ),
              const SizedBox(
                height: 28.0,
              ),
              StreamBuilder<bool>(
                stream: widget.cariPasienBloc.submitCari,
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: 45.0,
                    child: TextButton(
                      onPressed: snapshot.hasData ? widget.cariPasien : null,
                      style: TextButton.styleFrom(
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: kLightTextColor,
                        backgroundColor: snapshot.hasData
                            ? kSecondaryColor
                            : Colors.grey[200],
                      ),
                      child: const Text('Cari Pasien'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ResultPencarianPasien extends StatefulWidget {
  const ResultPencarianPasien({
    Key? key,
    required this.token,
    required this.cariPasienBloc,
    this.retry,
  }) : super(key: key);

  final String token;
  final CariPasienBloc cariPasienBloc;
  final Function()? retry;

  @override
  State<ResultPencarianPasien> createState() => _ResultPencarianPasienState();
}

class _ResultPencarianPasienState extends State<ResultPencarianPasien> {
  final DateFormat _formatDay = DateFormat('dd MMMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    widget.cariPasienBloc.tokenSink.add(widget.token);
    widget.cariPasienBloc.cariPasien();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseCariPasienModel>>(
      stream: widget.cariPasienBloc.cariPasienStream,
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
              if (!snapshot.data!.data!.success) {
                return StreamResponse(
                  image: 'images/server_error_1.png',
                  message: 'Pasien tidak ditemukan',
                  button: Container(
                    margin: const EdgeInsets.only(bottom: 18.0),
                    width: 180,
                    child: TextButton(
                      onPressed: widget.retry,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Coba lagi'),
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(22.0, 12.0, 8.0, 12.0),
                    decoration: const BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Informasi pasien',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            size: 22.0,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Norm',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  'Nama',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  'Tgl. Lahir',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ':',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 18.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data!.data!.pasien![0].norm}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  '${snapshot.data!.data!.pasien![0].nama}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  _formatDay.format(
                                    DateTime.parse(snapshot
                                        .data!.data!.pasien![0].tanggalLahir!),
                                  ),
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32.0,
                        ),
                        Center(
                          child: SizedBox(
                            width: 180,
                            height: 45,
                            child: TextButton(
                              onPressed: () => Navigator.pop(
                                  context, snapshot.data!.data!.pasien![0]),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[200],
                                backgroundColor: kSecondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: const Text(
                                'Konfirmasi',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        )
                      ],
                    ),
                  ),
                ],
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
