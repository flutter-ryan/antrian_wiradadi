import 'package:antrian_wiradadi/src/bloc/create_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/cara_bayar_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/error_create_antrian.dart';
import 'package:antrian_wiradadi/src/common/widget/loading_create_antrian.dart';
import 'package:antrian_wiradadi/src/common/widget/stream_antrian_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/text_field_widget.dart';
import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class PendaftaranBaruWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String idPoli;
  final String tanggal;
  final CreateAntrianBloc bloc;

  const PendaftaranBaruWidget({
    Key key,
    this.scrollController,
    this.idPoli,
    this.tanggal,
    this.bloc,
  }) : super(key: key);
  @override
  _PendaftaranBaruWidgetState createState() => _PendaftaranBaruWidgetState();
}

class _PendaftaranBaruWidgetState extends State<PendaftaranBaruWidget> {
  TokenBloc _tokenBloc = TokenBloc();
  final TextEditingController _namaCon = TextEditingController();
  final TextEditingController _tanggalLahirCon = TextEditingController();
  final TextEditingController _tempatLahirCon = TextEditingController();
  final TextEditingController _nomorPonselCon = TextEditingController();
  final TextEditingController _caraBayarCon = TextEditingController();

  final FocusNode _focusNama = FocusNode();
  final FocusNode _focusTanggalLahir = FocusNode();
  final FocusNode _focusNomorPonsel = FocusNode();
  final FocusNode _focusTempatLahir = FocusNode();

  bool _errorTanggal = false;
  bool _streamCreate = false;

  @override
  void initState() {
    super.initState();
    widget.bloc.norm.add("0");
    widget.bloc.jenis.add("2");
  }

  void _daftar() {
    setState(() {
      _errorTanggal = false;
      _streamCreate = true;
    });
    _tokenBloc.getToken();
  }

  void _batal() {
    setState(() {
      _streamCreate = false;
    });
  }

  void _pilihCaraBayar() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.0),
          topRight: Radius.circular(22.0),
        ),
      ),
      builder: (context) => CaraBayarWidget(
        caraBayarSelected:
            (BuildContext contextSheet, String id, String deskripsi) =>
                _caraBayarSelected(contextSheet, id, deskripsi),
      ),
    );
  }

  void _caraBayarSelected(BuildContext contextSheet, String id, deskripsi) {
    Future.delayed(
        Duration(milliseconds: 500), () => Navigator.pop(contextSheet));
    _caraBayarCon.text = deskripsi;
    widget.bloc.caraBayar.add(id);
  }

  @override
  void dispose() {
    _namaCon?.dispose();
    _tempatLahirCon?.dispose();
    _tanggalLahirCon?.dispose();
    _nomorPonselCon?.dispose();
    _focusNama?.dispose();
    _focusNomorPonsel?.dispose();
    _focusTanggalLahir?.dispose();
    _focusTempatLahir?.dispose();
    _caraBayarCon?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _streamCreate
              ? _buildTokenStream(context)
              : ListView(
                  physics: ClampingScrollPhysics(),
                  controller: widget.scrollController,
                  padding: EdgeInsets.only(top: 8.0, bottom: 18.0),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'Input Pendaftaran Baru',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    _errorTanggal
                        ? Container(
                            padding: EdgeInsets.all(18.0),
                            margin: EdgeInsets.only(
                                left: 32.0, right: 32.0, top: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            child: Text(
                              'Anda belum memilih jadwal',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : SizedBox(),
                    TextFieldWidget(
                      stream: widget.bloc.namaStream,
                      sink: widget.bloc.namaPasien,
                      controller: _namaCon,
                      focus: _focusNama,
                      hint: 'Nama pasien',
                      icon: Icon(Icons.assignment_ind),
                      inputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    TextFieldWidget(
                      stream: widget.bloc.tanggalLahirStream,
                      sink: widget.bloc.tanggalLahir,
                      controller: _tanggalLahirCon,
                      focus: _focusTanggalLahir,
                      hint: 'Tanggal lahir',
                      isCalendar: true,
                      icon: Icon(Icons.calendar_today),
                      inputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    TextFieldWidget(
                      stream: widget.bloc.nomorStream,
                      sink: widget.bloc.nomorKontak,
                      controller: _nomorPonselCon,
                      focus: _focusNomorPonsel,
                      hint: 'Nomor ponsel',
                      icon: Icon(Icons.mobile_friendly),
                      inputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 7.0, left: 32.0, right: 32.0),
                      child: TextField(
                        controller: _caraBayarCon,
                        readOnly: true,
                        style: TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 5.0),
                          prefixIcon: Icon(Icons.credit_card),
                          hintText: 'Pilih cara bayar',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: kSecondaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25.0),
                              ),
                            ),
                            child: Text('GANTI'),
                            textColor: Colors.red,
                            onPressed: _pilihCaraBayar,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 52.0,
                    ),
                    _buildStreamButton(context),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildStreamButton(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.submitBaru,
      builder: (context, snapshot) {
        return Center(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 60,
            height: 45,
            child: FlatButton(
              onPressed: snapshot.hasData ? _daftar : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              color: Colors.redAccent,
              textColor: Colors.white,
              disabledColor: Colors.redAccent.shade100,
              disabledTextColor: Colors.grey[200],
              child: Text('DAFTAR'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenStream(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingCreateAntrian(
                scrollController: widget.scrollController,
              );
            case Status.ERROR:
              return ErrorCreateAntrian(
                scrollController: widget.scrollController,
                daftar: _daftar,
                message: snapshot.data.message,
                button: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 18.0),
                        height: 45.0,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              _streamCreate = false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                          child: Text('BATAL'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18.0,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 18.0),
                        height: 45.0,
                        child: FlatButton(
                          onPressed: _daftar,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: Text('COBA LAGI'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case Status.COMPLETED:
              return StreamAntrianWidget(
                scrollController: widget.scrollController,
                bloc: widget.bloc,
                token: snapshot.data.data.response.token,
                daftar: _daftar,
                batal: _batal,
              );
          }
        }
        return Container();
      },
    );
  }
}
