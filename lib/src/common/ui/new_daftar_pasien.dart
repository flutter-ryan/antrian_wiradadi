import 'dart:async';

import 'package:antrian_wiradadi/src/bloc/cari_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/create_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_right_route.dart';
import 'package:antrian_wiradadi/src/common/widget/error_cari_pasien_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/new_home_page.dart';
import 'package:antrian_wiradadi/src/common/widget/body_tiket_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/cara_bayar_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/error_create_antrian_Widget.dart';
import 'package:antrian_wiradadi/src/common/widget/loading_cari_pasien_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/loading_create_antrian_widget.dart';
import 'package:antrian_wiradadi/src/model/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/model/create_antrian_model.dart';
import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDaftarPasien extends StatefulWidget {
  final int idJenis;
  final String tanggalKunjungan;
  final String idPoli;
  final String idJadwal;

  const NewDaftarPasien({
    Key key,
    this.idJenis,
    this.tanggalKunjungan,
    this.idPoli,
    this.idJadwal,
  }) : super(key: key);

  @override
  _NewDaftarPasienState createState() => _NewDaftarPasienState();
}

class _NewDaftarPasienState extends State<NewDaftarPasien> {
  CreateAntrianBloc _createAntrianBloc = CreateAntrianBloc();
  TokenBloc _tokenBloc = TokenBloc();
  TextEditingController _normCon = TextEditingController();
  TextEditingController _namaCon = TextEditingController();
  TextEditingController _tanggalLahirCon = TextEditingController();
  TextEditingController _kontakCon = TextEditingController();
  TextEditingController _caraBayar = TextEditingController();
  FocusNode _normFocus = FocusNode();
  FocusNode _namaFocus = FocusNode();
  FocusNode _tanggalLahirFocus = FocusNode();
  FocusNode _kontakFocus = FocusNode();
  FocusNode _caraBayarFocus = FocusNode();
  bool _stream = false;

  @override
  void initState() {
    super.initState();
    _createAntrianBloc.jenis.add(widget.idJenis.toString());
    _createAntrianBloc.tanggalKunjungan.add(widget.tanggalKunjungan);
    _createAntrianBloc.poli.add(widget.idPoli);
    _createAntrianBloc.idJadwalSink.add(widget.idJadwal);
    if (widget.idJenis == 2) {
      _createAntrianBloc.norm.add("0");
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 600), () {
          showGeneralDialog(
            context: context,
            transitionBuilder: (context, a1, a2, chil) {
              final curvedValue =
                  Curves.easeInOutBack.transform(a1.value) - 1.0;
              return Transform(
                transform:
                    Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                child: Opacity(
                  opacity: a1.value,
                  child: DialogPasienLama(
                    bloc: _createAntrianBloc,
                  ),
                ),
              );
            },
            pageBuilder: (context, a1, a2) {
              return;
            },
          ).then(
            (value) {
              if (value == null) {
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              } else {
                CariPasienResult cariPasienResult = value;
                _normCon.text = cariPasienResult.norm;
                _namaCon.text = cariPasienResult.nama;
                _tanggalLahirCon.text = cariPasienResult.tanggalLahir;
              }
            },
          );
        });
      });
    }
  }

  void _showCaraBayar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CaraBayarWidget(
          caraBayarSelected: (String id, String deskripsi) =>
              _pilihCaraBayar(id, deskripsi),
        );
      },
    );
  }

  void _pilihCaraBayar(String idCaraBayar, String deskripsi) {
    _caraBayar.text = deskripsi;
    _createAntrianBloc.caraBayar.add(idCaraBayar);
  }

  void _createAntrian() {
    _tokenBloc.getToken();
    setState(() {
      _stream = true;
    });
  }

  void _closeResponse() {
    setState(() {
      _stream = false;
    });
  }

  @override
  void dispose() {
    _normCon.dispose();
    _namaCon.dispose();
    _tanggalLahirCon.dispose();
    _kontakCon.dispose();
    _caraBayar.dispose();
    _normFocus.dispose();
    _namaFocus.dispose();
    _tanggalLahirFocus.dispose();
    _kontakFocus.dispose();
    _caraBayarFocus.dispose();
    _createAntrianBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 35,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2.0, 2.0),
                      )
                    ],
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_header.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text(
                        'RSU Wiradadi Husada',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.idJenis == 2
                    ? _buildPasienBaru(context)
                    : _buildPasienLama(context),
              ],
            ),
            Positioned(
              left: 18.0,
              top: MediaQuery.of(context).padding.top + 12,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2.0, 2.0),
                      )
                    ]),
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 38.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _stream ? _buildStreamToken(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasienBaru(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(
          top: 42.0,
          left: 32.0,
          right: 32.0,
          bottom: 22.0,
        ),
        children: [
          Text(
            'Pendaftaran Pasien Baru',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
          ),
          SizedBox(
            height: 32.0,
          ),
          InputFormWidget(
            controller: _namaCon,
            focus: _namaFocus,
            label: 'Nama',
            hint: 'Nama lengkap sesuai identitas',
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.name,
            sink: _createAntrianBloc.namaPasien,
            stream: _createAntrianBloc.namaStream,
            suffixIcon: Icon(Icons.person),
          ),
          InputFormWidget(
            controller: _tanggalLahirCon,
            focus: _tanggalLahirFocus,
            label: 'Tanggal lahir',
            hint: 'Tanggal lahir sesuai identitas',
            sink: _createAntrianBloc.tanggalLahir,
            stream: _createAntrianBloc.tanggalLahirStream,
            isReadOnly: true,
            isCalendar: true,
            suffixIcon: Icon(Icons.calendar_today),
          ),
          InputFormWidget(
            controller: _kontakCon,
            focus: _kontakFocus,
            label: 'Nomor Handphne',
            hint: 'Nomor handphone aktif Anda',
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.phone,
            suffixIcon: Icon(Icons.phone_android),
            sink: _createAntrianBloc.nomorKontak,
            stream: _createAntrianBloc.nomorStream,
          ),
          InputFormWidget(
            controller: _caraBayar,
            focus: _caraBayarFocus,
            label: 'Cara bayar',
            hint: 'Pilih cara bayar',
            sink: _createAntrianBloc.caraBayar,
            stream: _createAntrianBloc.idCaraBayarStream,
            isReadOnly: true,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: TextButton(
                onPressed: _showCaraBayar,
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6.0),
                        bottomRight: Radius.circular(6.0),
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    primary: Colors.white),
                child: Text('Ganti'),
              ),
            ),
          ),
          SizedBox(
            height: 18.0,
          ),
          _buildStreamButton(context),
        ],
      ),
    );
  }

  Widget _buildPasienLama(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(
          top: 42.0,
          left: 32.0,
          right: 32.0,
          bottom: 22.0,
        ),
        children: [
          Text(
            'Pendaftaran Pasien Lama',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
          ),
          SizedBox(
            height: 32.0,
          ),
          InputFormWidget(
            controller: _normCon,
            focus: _normFocus,
            label: 'Nomor Rm',
            hint: 'Nomor rm pasien',
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.name,
            sink: _createAntrianBloc.namaPasien,
            stream: _createAntrianBloc.namaStream,
            suffixIcon: Icon(Icons.person),
            isReadOnly: true,
          ),
          InputFormWidget(
            controller: _namaCon,
            focus: _namaFocus,
            label: 'Nama',
            hint: 'Nama lengkap sesuai identitas',
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.name,
            sink: _createAntrianBloc.namaPasien,
            stream: _createAntrianBloc.namaStream,
            suffixIcon: Icon(Icons.person),
            isReadOnly: true,
          ),
          InputFormWidget(
            controller: _tanggalLahirCon,
            focus: _tanggalLahirFocus,
            label: 'Tanggal lahir',
            hint: 'Tanggal lahir sesuai identitas',
            sink: _createAntrianBloc.tanggalLahir,
            stream: _createAntrianBloc.tanggalLahirStream,
            isReadOnly: true,
            isCalendar: true,
            suffixIcon: Icon(Icons.calendar_today),
          ),
          InputFormWidget(
            controller: _kontakCon,
            focus: _kontakFocus,
            label: 'Nomor Handphne',
            hint: 'Nomor handphone aktif Anda',
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.phone,
            suffixIcon: Icon(Icons.phone_android),
            sink: _createAntrianBloc.nomorKontak,
            stream: _createAntrianBloc.nomorStream,
          ),
          InputFormWidget(
            controller: _caraBayar,
            focus: _caraBayarFocus,
            label: 'Cara bayar',
            hint: 'Pilih cara bayar',
            sink: _createAntrianBloc.caraBayar,
            stream: _createAntrianBloc.idCaraBayarStream,
            isReadOnly: true,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: TextButton(
                onPressed: _showCaraBayar,
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6.0),
                        bottomRight: Radius.circular(6.0),
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    primary: Colors.white),
                child: Text('Ganti'),
              ),
            ),
          ),
          SizedBox(
            height: 18.0,
          ),
          _buildStreamButton(context),
        ],
      ),
    );
  }

  Widget _buildStreamButton(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.idJenis == 1
          ? _createAntrianBloc.submitLama
          : _createAntrianBloc.submitBaru,
      builder: (context, snapshot) {
        return Container(
          width: SizeConfig.screenWidth,
          height: 45.0,
          child: TextButton(
            onPressed: snapshot.hasData ? _createAntrian : null,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              backgroundColor: snapshot.hasData
                  ? kPrimaryColor
                  : kPrimaryColor.withAlpha(80),
              primary: Colors.black,
            ),
            child: Text('Daftar Sekarang'),
          ),
        );
      },
    );
  }

  Widget _buildStreamToken(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingCreateAntrianWidget();
            case Status.ERROR:
              return ErrorCreateAntrianWidget(
                title: 'Terjadi kesalahan',
                image: 'assets/images/server_error.png',
                message: snapshot.data.message,
              );
            case Status.COMPLETED:
              if (snapshot.data.data.metadata.code == 500) {
                return ErrorCreateAntrianWidget(
                  title: 'Perhatian',
                  image: 'assets/images/no_data.png',
                  message: snapshot.data.data.metadata.message,
                );
              }
              return StreamCreateAntrianWidget(
                token: snapshot.data.data.response.token,
                bloc: _createAntrianBloc,
                closeResponse: _closeResponse,
              );
          }
        }
        return Container();
      },
    );
  }
}

class StreamCreateAntrianWidget extends StatefulWidget {
  final String token;
  final CreateAntrianBloc bloc;
  final Function closeResponse;

  const StreamCreateAntrianWidget({
    Key key,
    this.token,
    this.bloc,
    this.closeResponse,
  }) : super(key: key);

  @override
  _StreamCreateAntrianWidgetState createState() =>
      _StreamCreateAntrianWidgetState();
}

class _StreamCreateAntrianWidgetState extends State<StreamCreateAntrianWidget> {
  @override
  void initState() {
    super.initState();
    widget.bloc.tokenSink.add(widget.token);
    widget.bloc.createAntrian();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseCreateAntrianModel>>(
      stream: widget.bloc.createAntrianStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingCreateAntrianWidget();
            case Status.ERROR:
              return ErrorCreateAntrianWidget(
                title: 'Terjadi kesalahan',
                message: snapshot.data.message,
                image: 'assets/images/server_error.png',
              );
            case Status.COMPLETED:
              if (!snapshot.data.data.success) {
                return ErrorCreateAntrianWidget(
                  title: 'Perhatian',
                  message: snapshot.data.data.metadata.message,
                  image: 'assets/images/no_data.png',
                );
              }
              return ResponseCreateAntrianWidget(
                data: snapshot.data.data.response,
                message: snapshot.data.data.metadata.message,
                closeResponse: widget.closeResponse,
              );
          }
        }
        return Container();
      },
    );
  }
}

class ResponseCreateAntrianWidget extends StatefulWidget {
  final Antrian data;
  final String message;
  final Function closeResponse;

  const ResponseCreateAntrianWidget({
    Key key,
    this.data,
    this.message,
    this.closeResponse,
  }) : super(key: key);

  @override
  _ResponseCreateAntrianWidgetState createState() =>
      _ResponseCreateAntrianWidgetState();
}

class _ResponseCreateAntrianWidgetState
    extends State<ResponseCreateAntrianWidget> {
  @override
  void initState() {
    super.initState();
    simpanAntrian();
  }

  void _lihatTiket() {
    showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, child) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: DialogTiket(),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, a1, a2) {
        return;
      },
    ).then((value) {
      Navigator.pop(context);
    });
    widget.closeResponse();
  }

  Future<void> simpanAntrian() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("nomorAntrian", widget.data.nomorantrean);
    _prefs.setString("tanggalKunjungan", widget.data.tanggalkunjungan);
    _prefs.setString("jamKunjungan", widget.data.jamkunjungan);
    _prefs.setString("poli", widget.data.namapoli);
    _prefs.setString("namaPasien", widget.data.namapasien);
    _prefs.setString("namaDokter", widget.data.jadwaldokter.namaDokter);
    _prefs.setString("mulaiJadwal", widget.data.jadwaldokter.mulai);
    _prefs.setString("selesaiJadwal", widget.data.jadwaldokter.selesai);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: SizeConfig.screenWidth,
          constraints: BoxConstraints(minHeight: 100.0),
          margin: EdgeInsets.symmetric(horizontal: 32.0),
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/doctor.png')),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Sukses',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '${widget.message}',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 32.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 45,
                      child: TextButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            SlideRightRoute(
                              page: NewHomePage(),
                            ),
                            (route) => false),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          textStyle: TextStyle(color: Colors.black),
                        ),
                        child: Text('Kembali',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 45,
                      child: TextButton(
                        onPressed: _lihatTiket,
                        style: TextButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Text('Lihat Tiket',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputFormWidget extends StatefulWidget {
  final String label;
  final String hint;
  final FocusNode focus;
  final TextEditingController controller;
  final Widget suffixIcon;
  final bool isReadOnly;
  final Stream stream;
  final StreamSink sink;
  final bool isCalendar;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool autofocus;

  const InputFormWidget({
    Key key,
    this.label,
    this.hint,
    this.focus,
    this.controller,
    this.suffixIcon,
    this.isReadOnly = false,
    this.stream,
    this.sink,
    this.isCalendar = false,
    this.textInputAction,
    this.textInputType,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _InputFormWidgetState createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  String _selectedDate;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_focusListener);
  }

  void _focusListener() {
    if (widget.isCalendar && widget.focus.hasFocus) {
      _showDatePicker();
    }
  }

  Future<Null> _showDatePicker() async {
    final DateTime _picked = await showDatePicker(
        context: context,
        locale: const Locale("id"),
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime(2030),
        builder: (context, Widget child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.redAccent,
                accentColor: Colors.redAccent,
                colorScheme: ColorScheme.light(primary: Colors.redAccent),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child);
        });
    if (_picked != null) {
      widget.focus.unfocus();
      FocusScope.of(context).nextFocus();
    } else {
      widget.focus.unfocus();
      FocusScope.of(context).previousFocus();
    }

    if (_picked != null &&
        DateFormat("yyyy-MM-dd").format(_picked) != _selectedDate) {
      widget.sink.add(DateFormat("yyyy-MM-dd").format(_picked));
      setState(() {
        _selectedDate = DateFormat("yyyy-MM-dd").format(_picked);
        widget.controller.text = DateFormat("yyyy-MM-dd").format(_picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stream,
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: TextField(
          focusNode: widget.focus,
          controller: widget.controller,
          readOnly: widget.isReadOnly,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            labelText: '${widget.label}',
            hintText: '${widget.hint}',
            errorText: snapshot.hasError ? snapshot.error : null,
            contentPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300],
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            suffixIcon: widget.suffixIcon,
          ),
          onChanged: (value) {
            widget.sink.add(value);
          },
        ),
      ),
    );
  }
}

class DialogTiket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: 18.0,
                left: 18.0,
                right: 18.0,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: TiketBodyWidget(),
            ),
            Positioned(
              top: Consts.avatarRadius + Consts.padding - 18,
              right: 1.0,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[500]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                radius: Consts.avatarRadius,
                child: Icon(
                  Icons.receipt,
                  size: 42.0,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogPasienLama extends StatefulWidget {
  final CreateAntrianBloc bloc;

  const DialogPasienLama({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  _DialogPasienLamaState createState() => _DialogPasienLamaState();
}

class _DialogPasienLamaState extends State<DialogPasienLama> {
  TokenBloc _tokenBloc = TokenBloc();
  CariPasienBloc _cariPasienBloc = CariPasienBloc();

  bool _streamCari = false;
  bool _result = false;

  void _cariPasien() {
    _tokenBloc.getToken();
    setState(() {
      _streamCari = true;
      _result = !_result;
    });
  }

  void _cobaLagi() {
    setState(() {
      _streamCari = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: 22.0,
                left: 22.0,
                right: 22.0,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: _streamCari
                  ? _buildTokenStream(context)
                  : CariPasienLama(
                      cariPasienBloc: _cariPasienBloc,
                      cari: _cariPasien,
                    ),
            ),
            Positioned(
              top: Consts.avatarRadius + Consts.padding - 18,
              right: 1.0,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[500]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                radius: Consts.avatarRadius,
                child: Icon(
                  Icons.receipt,
                  size: 42.0,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenStream(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingCariPasienWidget(message: snapshot.data.message);
            case Status.ERROR:
              return ErrorCaariPasienWidget(
                title: 'Terjadi kesalahan',
                message: snapshot.data.message,
                image: 'assets/images/server_error.png',
              );
            case Status.COMPLETED:
              if (snapshot.data.data.metadata.code == 500) {
                return ErrorCaariPasienWidget(
                  title: 'Perhatian',
                  message: snapshot.data.data.metadata.message,
                  image: 'assets/images/no_data.png',
                );
              }
              return StreamPencarianPasien(
                token: snapshot.data.data.response.token,
                createAntrianBloc: widget.bloc,
                cariPasienBloc: _cariPasienBloc,
                cobaLagi: _cobaLagi,
              );
          }
        }
        return Container();
      },
    );
  }
}

class StreamPencarianPasien extends StatefulWidget {
  final String token;
  final CreateAntrianBloc createAntrianBloc;
  final CariPasienBloc cariPasienBloc;
  final Function cobaLagi;

  const StreamPencarianPasien({
    Key key,
    this.token,
    this.createAntrianBloc,
    this.cariPasienBloc,
    this.cobaLagi,
  }) : super(key: key);

  @override
  _StreamPencarianPasienState createState() => _StreamPencarianPasienState();
}

class _StreamPencarianPasienState extends State<StreamPencarianPasien> {
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
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingCariPasienWidget(
                  message: snapshot.data.message,
                );
              case Status.ERROR:
                return ErrorCaariPasienWidget(
                  title: 'Terjadi kesalahan',
                  message: snapshot.data.message,
                  image: 'assets/images/server_error.png',
                );
              case Status.COMPLETED:
                if (!snapshot.data.data.success) {
                  return ErrorCaariPasienWidget(
                      title: 'Perhatian',
                      message: 'Pasien tidak ditemukan',
                      image: 'assets/images/no_data.png',
                      button: Container(
                        width: 180,
                        height: 45.0,
                        child: TextButton(
                          onPressed: () {
                            widget.cobaLagi();
                          },
                          child: Text('Coba Lagi'),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: kPrimaryColor,
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            onSurface: Colors.grey[300],
                          ),
                        ),
                      ));
                }
                var pasien = snapshot.data.data.pasien[0];
                return ResultPencarianPasien(
                  norm: pasien.norm,
                  nama: pasien.nama,
                  tempatLahir: pasien.tempatLahir,
                  tanggalLahir: pasien.tanggalLahir,
                  alamat: pasien.alamat,
                  cobaLagi: widget.cobaLagi,
                  createAntrian: widget.createAntrianBloc,
                );
            }
          }
          return Container();
        });
  }
}

class ResultPencarianPasien extends StatefulWidget {
  final String norm;
  final String nama;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String alamat;
  final Function cobaLagi;
  final CreateAntrianBloc createAntrian;

  const ResultPencarianPasien({
    Key key,
    this.norm,
    this.nama,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamat,
    this.cobaLagi,
    this.createAntrian,
  }) : super(key: key);

  @override
  _ResultPencarianPasienState createState() => _ResultPencarianPasienState();
}

class _ResultPencarianPasienState extends State<ResultPencarianPasien> {
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  CariPasienResult cariPasien;

  @override
  void initState() {
    super.initState();
    widget.createAntrian.norm.add(widget.norm);
    widget.createAntrian.namaPasien.add(widget.nama);
    widget.createAntrian.tanggalLahir
        .add(_dateFormat.format(widget.tanggalLahir));
    cariPasien = CariPasienResult(
      norm: widget.norm,
      nama: widget.nama,
      tanggalLahir: _dateFormat.format(widget.tanggalLahir),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'PASIEN LAMA',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          'Apakah pasien ini adalah Anda?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 24.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: Text('Nomor RM')),
            Expanded(flex: 2, child: Text(': ${widget.norm}'))
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: Text('Nama')),
            Expanded(flex: 2, child: Text(': ${widget.nama}'))
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: Text('Tanggal lahir')),
            Expanded(
                flex: 2,
                child: Text(': ${_dateFormat.format(widget.tanggalLahir)}'))
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: Text('Alamat')),
            Expanded(flex: 2, child: Text(': ${widget.alamat}'))
          ],
        ),
        SizedBox(
          height: 28.0,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 42.0,
                child: TextButton(
                  onPressed: widget.cobaLagi,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    backgroundColor: Colors.grey[300],
                    primary: Colors.black,
                  ),
                  child: Text('Coba lagi'),
                ),
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 42.0,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, cariPasien),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: kPrimaryColor,
                    primary: Colors.black,
                  ),
                  child: Text('Ya, lanjutkan'),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '*)',
              style: TextStyle(color: Colors.redAccent, fontSize: 12.0),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                'Apabila ada ketidaksesuain informasi, harap untuk menginformasikan kepada petugas pada saat kunjungan',
                style: TextStyle(color: Colors.redAccent, fontSize: 12.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CariPasienLama extends StatefulWidget {
  final CariPasienBloc cariPasienBloc;
  final Function cari;
  final String message;

  const CariPasienLama({Key key, this.cariPasienBloc, this.cari, this.message})
      : super(key: key);

  @override
  _CariPasienLamaState createState() => _CariPasienLamaState();
}

class _CariPasienLamaState extends State<CariPasienLama> {
  TextEditingController _normCon = TextEditingController();
  TextEditingController _tanggalLahirCon = TextEditingController();
  FocusNode _focusNorm = FocusNode();
  FocusNode _focusTanggalLahir = FocusNode();
  bool _noMessage = false;

  @override
  void initState() {
    super.initState();

    if (widget.message != null) {
      _noMessage = true;
      Future.delayed(Duration(milliseconds: 3000), () {
        setState(() {
          _noMessage = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _normCon.dispose();
    _tanggalLahirCon.dispose();
    _focusNorm.dispose();
    _focusTanggalLahir.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'PASIEN LAMA',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          'Untuk pendaftaran pasien lama kami membutuhkan nomor RM Anda untuk konfirmasi.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        widget.message != null && _noMessage
            ? Container(
                margin: const EdgeInsets.only(top: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'Pasien tidak ditemukan. Silahkan coba lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(),
        SizedBox(
          height: 32.0,
        ),
        InputFormWidget(
          controller: _normCon,
          focus: _focusNorm,
          label: 'Nomor RM',
          hint: 'Nomor RM',
          autofocus: true,
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.phone,
          suffixIcon: Icon(Icons.assignment),
          sink: widget.cariPasienBloc.noRm,
          stream: widget.cariPasienBloc.noRmStream,
        ),
        InputFormWidget(
          controller: _tanggalLahirCon,
          focus: _focusTanggalLahir,
          label: 'Tanggal lahir',
          hint: 'Tanggal lahir sesuai identitas',
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.phone,
          suffixIcon: Icon(Icons.calendar_today),
          isReadOnly: true,
          isCalendar: true,
          sink: widget.cariPasienBloc.tanggalLahir,
          stream: widget.cariPasienBloc.tanggalLahirStream,
        ),
        SizedBox(
          height: 22.0,
        ),
        _buildStreamSubmit(context),
        SizedBox(height: 18.0),
      ],
    );
  }

  Widget _buildStreamSubmit(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.cariPasienBloc.submitStream,
      builder: (context, snapshot) {
        return Container(
          width: 140,
          height: 45,
          child: TextButton(
              onPressed: snapshot.hasData ? widget.cari : null,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                backgroundColor: snapshot.hasData
                    ? kPrimaryColor
                    : kPrimaryColor.withAlpha(100),
              ),
              child: Text(
                'Cari Pasien',
                style: TextStyle(
                  color: snapshot.hasData ? Colors.black : Colors.grey[400],
                ),
              )),
        );
      },
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 42.0;
}

class CariPasienResult {
  final String norm;
  final String nama;
  final String tanggalLahir;

  CariPasienResult({
    this.norm,
    this.nama,
    this.tanggalLahir,
  });
}
