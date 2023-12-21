import 'package:antrian_wiradadi/src/blocs/pendaftaran_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/rujukan_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/db_helper_identitas.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/confg/transition/slide_bottom_route.dart';
import 'package:antrian_wiradadi/src/models/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/models/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/models/rujukan_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/form_pasien_baru.dart';
import 'package:antrian_wiradadi/src/pages/components/identitas_pasien.dart';
import 'package:antrian_wiradadi/src/pages/components/input_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/konfirmasi_idantitas_pasien.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:antrian_wiradadi/src/pages/components/stream_cara_bayar.dart';
import 'package:antrian_wiradadi/src/pages/components/stream_jadwal_dokter.dart';
import 'package:antrian_wiradadi/src/pages/create_tiket_antrian.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PendaftaranPage extends StatefulWidget {
  const PendaftaranPage({
    super.key,
    required this.poli,
  });

  final Poliklinik poli;

  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  final _pendaftaranPasienBloc = PendaftaranPasienBloc();
  final _tokenBloc = TokenBloc();
  final _dbHelperIdentitas = DbHelperIdentitas();
  final _tanggal = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final _nomorBpjs = TextEditingController();
  final _nomorRujukan = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ResponseSelectDb? _identitas;
  CaraBayar? _caraBayar;
  JadwalDokter? _jadwalDokter;
  bool _reloadDate = false;
  int _rujukanLength = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    _getIdentitas();
  }

  void _getIdentitas() async {
    var data = await _dbHelperIdentitas.getRowIdentitas(1);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _identitas = data;
    });
    if (!data.success) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showCekIdentitas();
      });
      return;
    }
    _nomorBpjs.text = '${data.data?.nomorBpjs}';
  }

  void _showCekIdentitas() {
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return const KonfirmasiIdentitasPasien();
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as ResponseCekIdentitas;
        if (data.jenis == 'pasien-baru') {
          Future.delayed(const Duration(milliseconds: 300), () {
            _showFormPasienBaru();
          });
        } else {
          _getIdentitas();
        }
      }
    });
  }

  void _pilihIdentitas() {
    if (_identitas?.data == null) {
      _showCekIdentitas();
      return;
    }
    Navigator.push(
      context,
      SlideBottomRoute(
        page: const IdentitasPasien(),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          _identitas = null;
        });
        _getIdentitas();
      }
    });
  }

  void _setJadwal(JadwalDokter data) {
    setState(() {
      _jadwalDokter = data;
    });
  }

  void _setCaraBayar(CaraBayar data) {
    setState(() {
      _caraBayar = data;
    });
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  SnackBar snackBar(String msg) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.only(left: 22.0),
        child: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.red[700],
      // behavior: SnackBarBehavior.floating,
      elevation: 22,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {},
      ),
    );
    return snackBar;
  }

  void _simpan() {
    if (_identitas?.data == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Anda belum mendaftarkan identitas pasien'));
      return;
    }
    if (_jadwalDokter == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Anda belum memilih jadwal dokter'));
      return;
    }
    if (_caraBayar == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Anda belum memilih cara pembayaran'));
      return;
    }
    _pendaftaranPasienBloc.jenisSink.add(_identitas!.data!.jenisPasien!);
    if (_identitas!.data!.jenisPasien == "1") {
      _pendaftaranPasienBloc.normSink.add(_identitas!.data!.norm!);
    }
    _pendaftaranPasienBloc.namaSink.add(_identitas!.data!.nama!);
    _pendaftaranPasienBloc.nikSink.add(_identitas!.data!.nik!);
    _pendaftaranPasienBloc.tanggalLahirSink.add(_identitas!.data!.tanggal!);
    _pendaftaranPasienBloc.contactSink.add(_identitas!.data!.kontak!);
    _pendaftaranPasienBloc.poliSink.add(widget.poli.id!);
    _pendaftaranPasienBloc.poliBpjsSink.add(_jadwalDokter!.kdSubSpesialis!);
    _pendaftaranPasienBloc.caraBayarSink.add(_caraBayar!.id!);
    _pendaftaranPasienBloc.dokterSink.add(_jadwalDokter!.kdDokter!);
    _pendaftaranPasienBloc.jamPraktekSink.add(_jadwalDokter!.jam!);
    _pendaftaranPasienBloc.tanggalKunjunganSink
        .add(_tanggal.format(_selectedDate));
    if (_caraBayar!.id == "2") {
      _pendaftaranPasienBloc.noKartuSink.add(_nomorBpjs.text);
      _pendaftaranPasienBloc.noRefSink.add(_nomorRujukan.text);
    }
    _showStreamTokenPendaftaran();
  }

  void _showStreamTokenPendaftaran() {
    _tokenBloc.getToken();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _streamTokenPendaftaran(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) async {
      if (value != null) {
        if (_identitas?.data!.nomorBpjs == null && _caraBayar!.id == '2') {
          await _dbHelperIdentitas.updateNoBpjs(
              _nomorBpjs.text, _identitas?.data!.id);
        }
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        Navigator.pop(context);
      }
    });
  }

  void _selanjutnya() {
    if (_jadwalDokter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar('Anda belum memilih dokter'),
      );
      return;
    }
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formAsuransi(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        if (data == 'rujukan') {
          _streamRujukan();
        } else {
          _simpan();
        }
      }
    });
  }

  void _showRujukan() {
    if (_nomorBpjs.text.isEmpty && _identitas!.data!.nomorBpjs == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Nomor bpjs tidak ditemukan'));
      return;
    }
    Navigator.pop(context, 'rujukan');
  }

  void _streamRujukan() {
    _tokenBloc.getToken();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _streamToken(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var nomorRujukan = value as String;
        _nomorRujukan.text = nomorRujukan;
        _rujukanLength = _nomorRujukan.text.length;
        _selanjutnya();
      }
    });
  }

  void _showFormPasienBaru() {
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const FormPasienBaru(),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as IdentitasPasienSql;
        setState(() {
          _identitas = ResponseSelectDb(
            success: true,
            data: data,
          );
        });
      } else {
        if (!_identitas!.success) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showCekIdentitas();
          });
        }
      }
    });
  }

  void _confirmClosePage() {
    if (_identitas!.data?.jenisPasien == '2') {
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return ResponseModalBottom(
            title: 'Anda yakin ingin keluar dari halaman ini?',
            message:
                'Saat menutup halaman ini identitas yang Anda inputkan akan dihapus.',
            button: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      minimumSize: const Size.fromHeight(45),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'konfirmasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    child: const Text('Ya, Saya Yakin'),
                  ),
                ),
              ],
            ),
          );
        },
        duration: const Duration(milliseconds: 500),
      ).then((value) async {
        if (value != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    _nomorBpjs.dispose();
    _nomorRujukan.dispose();
    _pendaftaranPasienBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: const Text('Pendaftaran Antrian'),
        leading: IconButton(
            onPressed: _confirmClosePage, icon: const Icon(Icons.arrow_back)),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.grey[50],
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: _identitas != null
          ? Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: SizeConfig.screenHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            child: Text(
                              'Poliklinik',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Divider(
                            height: 12,
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 18.0),
                            leading: Container(
                              height: 52,
                              width: 52,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withAlpha(100),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Image.asset('images/health_black.png'),
                            ),
                            title: Text(
                              '${widget.poli.deskripsi}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('${widget.poli.mulai}'),
                          ),
                          Divider(
                            height: 28.0,
                            thickness: 6,
                            color: Colors.grey[200],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Identitas Pasien',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                InkWell(
                                  onTap: _pilihIdentitas,
                                  child: const Text(
                                    'Ganti identitas',
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 12,
                          ),
                          if (!_identitas!.success)
                            const Padding(
                              padding: EdgeInsets.all(22.0),
                              child: Center(
                                child: Text(
                                  'Anda belum memilih identitas. Silahkan menyimpan informasi identitas Anda terlebih dahulu atau Anda bisa melakukan pendaftaran sebagai pasien baru',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )
                          else if (!_identitas!.success)
                            const Padding(
                              padding: EdgeInsets.all(22.0),
                              child: Center(
                                child: Text(
                                  'Anda belum memilih identitas. Silahkan menyimpan informasi identitas Anda terlebih dahulu atau Anda bisa melakukan pendaftaran sebagai pasien baru',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )
                          else
                            _identitasPasienWidget(context),
                          if (_identitas!.data != null)
                            const SizedBox(
                              height: 12,
                            ),
                          if (_identitas!.data != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: ElevatedButton(
                                onPressed: _showFormPasienBaru,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor.withAlpha(200),
                                  minimumSize: const Size(double.infinity, 45),
                                ),
                                child: const Text('Pasien Baru'),
                              ),
                            ),
                          Divider(
                            height: 28.0,
                            thickness: 6,
                            color: Colors.grey[200],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            child: Text(
                              'Tanggal Kunjungan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Divider(
                            height: 12.0,
                          ),
                          CalendarDatePicker2(
                            value: [_selectedDate],
                            config: CalendarDatePicker2Config(
                              currentDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              selectedDayHighlightColor:
                                  kPrimaryColor.withAlpha(200),
                              lastDate: DateTime.now().add(
                                const Duration(days: 30),
                              ),
                            ),
                            onValueChanged: (date) {
                              setState(() {
                                _jadwalDokter = null;
                                _reloadDate = !_reloadDate;
                                _selectedDate = date.first!;
                              });
                            },
                          ),
                          Divider(
                            height: 0.0,
                            thickness: 6,
                            color: Colors.grey[200],
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          StreamJadwalDokter(
                            poliRef: widget.poli.referensi!.penjaminRuangan,
                            tanggal: _tanggal.format(_selectedDate),
                            setJadwal: _setJadwal,
                            reloadDate: _reloadDate,
                            penjamin: widget.poli.referensi!.penjaminRuangan,
                          ),
                          Divider(
                            height: 28.0,
                            thickness: 6,
                            color: Colors.grey[200],
                          ),
                          StreamCaraBayar(setCaraBayar: _setCaraBayar),
                          const SizedBox(
                            height: 22.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (_caraBayar != null && _caraBayar!.id == "2")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _selanjutnya,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        backgroundColor: kPrimaryColor.withAlpha(200),
                      ),
                      child: const Text('SELANJUTNYA'),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 22.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _simpan,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: kPrimaryColor.withAlpha(200),
                        ),
                        child: const Text('SIMPAN'),
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: LoadingWidget(height: SizeConfig.blockSizeVertical * 35)),
    );
  }

  Widget _formAsuransi(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input data BPJS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            if (_identitas!.data!.nomorBpjs == null ||
                _identitas!.data!.nomorBpjs == '')
              InputNomorKartu(
                nomorBpjs: _nomorBpjs,
              ),
            if (_identitas!.data!.nomorBpjs == null ||
                _identitas!.data!.nomorBpjs == '')
              const SizedBox(
                height: 22,
              ),
            InputNomorRujukan(
              nomorRujukan: _nomorRujukan,
              showRujukan: _showRujukan,
              length: _rujukanLength,
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_caraBayar!.id == "2" && !validateAndSave()) {
                  return;
                }
                Navigator.pop(context, 'simpan');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: kPrimaryColor.withAlpha(200),
              ),
              child: const Text('SIMPAN'),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamTokenPendaftaran(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
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
              if (snapshot.data!.data!.metadata!.code != 200) {
                return ResponseModalBottom(
                  title: 'Perhatian',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return CreateTiketAntrian(
                token: snapshot.data!.data!.response!.token!,
                bloc: _pendaftaranPasienBloc,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }

  Widget _streamToken(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(
                height: SizeConfig.blockSizeVertical * 30,
              );
            case Status.error:
              return ResponseModalBottom(
                message: snapshot.data!.message,
                image: 'images/sorry.png',
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return ResponseModalBottom(
                  message: snapshot.data!.data!.metadata!.message,
                  title: 'Peringatan',
                  image: 'images/sorry.png',
                );
              }
              return StreamListRujukan(
                token: snapshot.data!.data!.response!.token!,
                nomor: _nomorBpjs.text,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 30,
        );
      },
    );
  }

  Widget _identitasPasienWidget(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
      title: Text(
        '${_identitas!.data!.nama}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
          _identitas!.data!.jenisPasien == "1" ? 'Pasien Lama' : 'Pasien Baru'),
      leading: Container(
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kPrimaryColor.withAlpha(100),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Image.asset('images/patient.png'),
      ),
    );
  }
}

class StreamListRujukan extends StatefulWidget {
  const StreamListRujukan({
    super.key,
    required this.token,
    required this.nomor,
  });

  final String token;
  final String nomor;

  @override
  State<StreamListRujukan> createState() => _StreamListRujukanState();
}

class _StreamListRujukanState extends State<StreamListRujukan> {
  final _rujukanBloc = RujukanBloc();

  @override
  void initState() {
    super.initState();
    _getRujukan();
  }

  void _getRujukan() {
    _rujukanBloc.tokenSink.add(widget.token);
    _rujukanBloc.noKartuSink.add(widget.nomor);
    _rujukanBloc.faskesSink.add(2);
    _rujukanBloc.getRujukan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<RujukanModel>>(
      stream: _rujukanBloc.rujukanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(height: SizeConfig.blockSizeVertical * 30);
            case Status.error:
              return ResponseModalBottom(
                message: snapshot.data!.message,
                title: 'Peringatan',
                image: 'images/sorry.png',
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return StreamNextListRujukan(
                  token: widget.token,
                  nomor: widget.nomor,
                );
              }

              var data = snapshot.data!.data!.data!;
              return ListTileRujukan(data: data);
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 30,
        );
      },
    );
  }
}

class StreamNextListRujukan extends StatefulWidget {
  const StreamNextListRujukan({
    super.key,
    required this.token,
    required this.nomor,
  });

  final String token;
  final String nomor;

  @override
  State<StreamNextListRujukan> createState() => _StreamNextListRujukanState();
}

class _StreamNextListRujukanState extends State<StreamNextListRujukan> {
  final _rujukanBloc = RujukanBloc();
  @override
  void initState() {
    super.initState();
    _getRujukan();
  }

  void _getRujukan() {
    _rujukanBloc.tokenSink.add(widget.token);
    _rujukanBloc.noKartuSink.add(widget.nomor);
    _rujukanBloc.faskesSink.add(1);
    _rujukanBloc.getRujukan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<RujukanModel>>(
      stream: _rujukanBloc.rujukanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(height: SizeConfig.blockSizeVertical * 30);
            case Status.error:
              return ResponseModalBottom(
                message: snapshot.data!.message,
                title: 'Peringatan',
                image: 'images/sorry.png',
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return ResponseModalBottom(
                  message: 'Nomor rujukan tidak ditemukan',
                  titleMessage2: 'Nomor kartu BPJS: ${widget.nomor}',
                  message2:
                      'Catatan: Bagi pasien yang tidak memiliki nomor rujukan, silahkan memilih cara bayar/penjamin lainnya atau kembali ke faskes awal untuk mengambil nomor rujukan',
                  title: 'Peringatan',
                  image: 'images/sorry.png',
                );
              }
              var data = snapshot.data!.data!.data!;
              return ListTileRujukan(data: data);
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 30,
        );
      },
    );
  }
}

class InputNomorKartu extends StatefulWidget {
  const InputNomorKartu({
    super.key,
    required this.nomorBpjs,
    this.readOnly = false,
  });

  final TextEditingController nomorBpjs;
  final bool readOnly;

  @override
  State<InputNomorKartu> createState() => _InputNomorKartuState();
}

class _InputNomorKartuState extends State<InputNomorKartu> {
  int? _bpjsLength;

  @override
  void initState() {
    super.initState();
    _bpjsLength = widget.nomorBpjs.text.length;
    widget.nomorBpjs.addListener(_listenNomorBpjs);
  }

  void _listenNomorBpjs() {
    setState(() {
      _bpjsLength = widget.nomorBpjs.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputFormField(
      controller: widget.nomorBpjs,
      label: 'Nomor Kartu',
      hint: 'Input nomor kepesartaan BPJS',
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validate: true,
      charLength: 13,
      charLengthValidate: true,
      counterText: '$_bpjsLength/13',
      readOnly: widget.readOnly,
      counterStyle: TextStyle(
          color: _bpjsLength == 13 ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600),
    );
  }
}

class InputNomorRujukan extends StatefulWidget {
  const InputNomorRujukan({
    super.key,
    required this.nomorRujukan,
    this.showRujukan,
    this.readOnly = false,
    this.length = 0,
  });

  final TextEditingController nomorRujukan;
  final VoidCallback? showRujukan;
  final bool readOnly;
  final int length;

  @override
  State<InputNomorRujukan> createState() => _InputNomorRujukanState();
}

class _InputNomorRujukanState extends State<InputNomorRujukan> {
  int _rujukanLength = 0;

  @override
  void initState() {
    super.initState();
    _rujukanLength = widget.length;
  }

  @override
  Widget build(BuildContext context) {
    return InputFormField(
      controller: widget.nomorRujukan,
      label: 'Nomor Rujukan',
      hint: 'Input nomor rujukan Faskes',
      validate: true,
      textInputAction: TextInputAction.done,
      charLength: 19,
      charLengthValidate: true,
      textCapitalization: TextCapitalization.none,
      counterText: '$_rujukanLength/19',
      readOnly: widget.readOnly,
      counterStyle: TextStyle(
          color: _rujukanLength == 19 ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600),
      buttonSearch: ElevatedButton(
        onPressed: widget.showRujukan,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor.withAlpha(200),
          elevation: 0.0,
          minimumSize: const Size(62, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Icon(Icons.search_rounded),
      ),
      onChanged: (value) {
        setState(() {
          _rujukanLength = value.length;
        });
      },
    );
  }
}

class ListTileRujukan extends StatelessWidget {
  const ListTileRujukan({
    super.key,
    required this.data,
  });

  final DataRujukan data;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
            child: Text(
              'Data Rujukan',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 22.0),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var rujukan = data.rujukan![i];
                return ListTile(
                  onTap: () => Navigator.pop(context, rujukan.noKunjungan),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18, horizontal: 22.0),
                  title: Text('${rujukan.noKunjungan}'),
                  tileColor: i % 2 == 0 ? Colors.grey[200] : Colors.transparent,
                  subtitle: Text(
                      '${rujukan.peserta!.nama} / ${rujukan.poliRujukan!.nama!} / ${rujukan.tglKunjungan}'),
                );
              },
              separatorBuilder: (context, i) => const SizedBox(
                height: 0,
              ),
              itemCount: data.rujukan!.length,
            ),
          )
        ]);
  }
}
