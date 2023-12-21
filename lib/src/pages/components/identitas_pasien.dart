import 'dart:io';

import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/db_helper_identitas.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:antrian_wiradadi/src/pages/components/date_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/error_resp_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/input_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/pencarian_pasien_lama.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class IdentitasPasien extends StatefulWidget {
  const IdentitasPasien({
    super.key,
    this.quick = false,
    this.form = false,
  });

  final bool quick;
  final bool form;

  @override
  State<IdentitasPasien> createState() => _IdentitasPasienState();
}

class _IdentitasPasienState extends State<IdentitasPasien> {
  final _tokenBloc = TokenBloc();
  final _dbIdentitas = DbHelperIdentitas();
  List<IdentitasPasienSql> _identitas = [];
  bool _isLoadingIdentitas = true;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _loadIdentitas();
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

  Future<void> _loadIdentitas() async {
    _identitas = await _dbIdentitas.getIdentitas();
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoadingIdentitas = false;
    });
    if (_identitas.isEmpty && widget.form) {
      _tambahPasien();
    }
  }

  void _tambahPasien() {
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: PencarianPasienLama(
            jenis: 1,
            dbHelper: _dbIdentitas,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<IdentitasPasienSql>;
        setState(() {
          _isLoadingIdentitas = true;
          _identitas = data;
        });
        _loadIdentitas();
      }
    });
  }

  void _selectedPasien(IdentitasPasienSql data) {
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return _modalSelectecPasien(context, data);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        setState(() {
          _isloading = true;
        });
        Future.delayed(const Duration(milliseconds: 600), () async {
          var data = value as IdentitasPasienSql;
          int status = 1;
          List<Map> cek = await _dbIdentitas.cekStatus(status);
          if (cek.isNotEmpty) {
            await _dbIdentitas.updateStatus(0, null);
          }
          await _dbIdentitas.updateStatus(1, data.id);
          _loadIdentitas();
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            _isloading = false;
          });
          if (!widget.quick) {
            Future.delayed(const Duration(milliseconds: 600), () {
              Navigator.pop(context, data);
            });
          }
        });
      }
    });
  }

  void _edit(IdentitasPasienSql data) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormIdentitasPasien(
            jenis: int.parse(data.jenisPasien!),
            dbHelper: _dbIdentitas,
            data: data,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        setState(() {
          _isLoadingIdentitas = true;
        });
        _loadIdentitas();
      }
    });
  }

  void _delete(int? id) {
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return ResponseModalBottom(
          image: 'images/ask.png',
          title: 'Anda yakin menghapus identitas pasien ini?',
          message:
              'Anda akan menghapus identitas pasien secara permanen. Pastikan bahwa Anda memilih identitas yang benar',
          button: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  elevation: 0.0,
                ),
                child: const Text('Batalkan'),
              )),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'hapus'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(45),
                    backgroundColor: Colors.red,
                    elevation: 0.0,
                  ),
                  child: const Text('Ya, Hapus'),
                ),
              )
            ],
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) async {
      if (value != null) {
        var delete = await _dbIdentitas.removeIdentitas(id!);
        if (!mounted) return;
        if (delete == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar(
              'Terjadi kesalahan tidak dapat menghapus data identitas, Silahkan coba lagi'));
          return;
        }
        setState(() {
          _isLoadingIdentitas = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar('Sukses menghapus data identitas'));
        _loadIdentitas();
      }
    });
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Identitas Pasien',
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _identitas),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.grey[50],
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 30,
            color: kPrimaryColor,
          ),
          if (_isLoadingIdentitas)
            const LoadingWidget(height: double.infinity)
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 55,
                ),
                Expanded(child: _listIdenitasPasien(context)),
                Container(
                  padding: EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 18.0,
                      bottom: Platform.isAndroid ? 18.0 : 0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -2),
                      )
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: ElevatedButton(
                      onPressed: _tambahPasien,
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryDarkColor,
                        minimumSize: const Size.fromHeight(45),
                      ),
                      child: const Text('Tambah Identitas'),
                    ),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  Widget _listIdenitasPasien(BuildContext context) {
    if (_identitas.isEmpty) {
      return Center(
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 80,
          height: SizeConfig.blockSizeVertical * 50,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 12.0,
                )
              ]),
          child: const ErrorRespWidget(
            height: 200,
            message:
                'Data tidak tersedia,\nTap "Tambah Identitas untuk menambahkan data baru"',
          ),
        ),
      );
    }
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(18.0),
          itemBuilder: (context, i) {
            var data = _identitas[i];
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor, width: 0.8),
                  borderRadius: BorderRadius.circular(8.0),
                  color: data.status == 1 ? kCardLightColor : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(2.0, 2.0),
                    )
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectedPasien(data),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (data.jenisPasien == "2")
                                const Text(
                                  'Pasien Baru',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                )
                              else
                                const Text(
                                  'Pasien Lama',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              if (data.status == 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white),
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          TileIdentitas(
                            title: 'NIK',
                            subtitle: '${data.nik}',
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          if (data.jenisPasien == "1")
                            TileIdentitas(
                              title: 'Nomor RM',
                              subtitle: '${data.norm}',
                            ),
                          if (data.jenisPasien == "1")
                            const SizedBox(
                              height: 8.0,
                            ),
                          TileIdentitas(
                            title: 'Nama',
                            subtitle: '${data.nama}',
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TileIdentitas(
                            title: 'Tanggal lahir',
                            subtitle: '${data.tanggal}',
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TileIdentitas(
                            title: 'Nomor Hp',
                            subtitle: '${data.kontak}',
                          ),
                          if (data.nomorBpjs != null)
                            const SizedBox(
                              height: 8.0,
                            ),
                          if (data.nomorBpjs != null)
                            TileIdentitas(
                              title: 'Nomor BPJS',
                              subtitle: '${data.nomorBpjs}',
                            ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _delete(data.id),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(60, 45),
                                  backgroundColor: Colors.grey[100],
                                  foregroundColor: Colors.red,
                                ),
                                child: const Icon(Icons.delete_rounded),
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _edit(data),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(45),
                                    backgroundColor:
                                        kPrimaryColor.withAlpha(200),
                                  ),
                                  child: const Text('Edit Identitas'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, i) => const SizedBox(
            height: 18.0,
          ),
          itemCount: _identitas.length,
        ),
        if (_isloading)
          Container(
            color: Colors.black54,
            child: const Center(child: LoadingWidget(height: 150)),
          ),
      ],
    );
  }

  Widget _modalSelectecPasien(BuildContext context, IdentitasPasienSql data) {
    return ResponseModalBottom(
      image: 'images/ask.png',
      title: 'Anda yakin memilih identitas pasien ini?',
      message:
          'Setelah konfirmasi Anda akan menjadikan identitas pasien ini sebagai pilihan default',
      button: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  minimumSize: const Size.fromHeight(45),
                  elevation: 0.0),
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, data),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              child: const Text('Konfirmasi'),
            ),
          )
        ],
      ),
    );
  }
}

class TileIdentitas extends StatelessWidget {
  const TileIdentitas({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
        const SizedBox(
          width: 18.0,
        ),
        Flexible(
          child: Text(
            subtitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}

class FormIdentitasPasien extends StatefulWidget {
  const FormIdentitasPasien({
    super.key,
    required this.jenis,
    this.data,
    required this.dbHelper,
    this.pasien,
  });

  final int jenis;
  final DbHelperIdentitas dbHelper;
  final IdentitasPasienSql? data;
  final Pasien? pasien;

  @override
  State<FormIdentitasPasien> createState() => _FormIdentitasPasienState();
}

class _FormIdentitasPasienState extends State<FormIdentitasPasien> {
  final _sc = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _norm = TextEditingController();
  final _nik = TextEditingController();
  final _nikFocus = FocusNode();
  final _nama = TextEditingController();
  final _tanggal = TextEditingController();
  final _kontak = TextEditingController();
  final _nomorBpjs = TextEditingController();
  bool _loadingSave = false;
  int _nikLength = 0;
  int _bpjsLength = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) _editIdentitas();
    if (widget.pasien != null) _getPasien();
    _nomorBpjs.addListener(_nomorBpjsListen);
  }

  void _getPasien() {
    _norm.text = '${widget.pasien?.norm}';
    _nama.text = '${widget.pasien?.nama}';
    _tanggal.text = '${widget.pasien?.tanggalLahir}';
    if (widget.pasien?.kartuIdentitas != null) {
      _nik.text = '${widget.pasien?.kartuIdentitas?.first.nomor}';
    }
    if (widget.pasien?.kontakPasien != null) {
      _kontak.text = '${widget.pasien?.kontakPasien?.first.nomor}';
    }
    if (widget.pasien?.kartuAsuransi != null) {
      var data = widget.pasien?.kartuAsuransi?.where((e) => e.jenis == "2");
      if (data!.isNotEmpty) {
        _nomorBpjs.text = '${data.first.nomor}';
      }
    }
  }

  void _nomorBpjsListen() {
    setState(() {
      _bpjsLength = _nomorBpjs.text.length;
    });
  }

  void _editIdentitas() {
    _norm.text = '${widget.data!.norm}';
    _nik.text = '${widget.data!.nik}';
    _nikLength = _nik.text.characters.length;
    _nama.text = '${widget.data!.nama}';
    _tanggal.text = '${widget.data!.tanggal}';
    _kontak.text = '${widget.data!.kontak}';
    _nomorBpjs.text = '${widget.data!.nomorBpjs}';
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> _simpan() async {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      setState(() {
        _loadingSave = true;
      });
      var identitas = IdentitasPasienSql(
        jenisPasien: "1",
        nama: _nama.text,
        nik: _nik.text,
        tanggal: _tanggal.text,
        norm: _norm.text,
        kontak: _kontak.text,
        nomorBpjs: _nomorBpjs.text,
        status: 1,
      );
      ResponseDb? simpan = await widget.dbHelper.createIdentitas(identitas);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (simpan!.success) {
        setState(() {
          _loadingSave = false;
        });
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        _responseSuccess(simpan);
      } else {
        setState(() {
          _loadingSave = false;
        });
        await Future.delayed(
          const Duration(milliseconds: 600),
        );
        _responseError(simpan.message);
      }
    }
  }

  Future<void> _update() async {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      setState(() {
        _loadingSave = true;
      });
      var identitas = IdentitasPasienUpdateSql(
        jenisPasien: "1",
        nama: _nama.text,
        nik: _nik.text,
        tanggal: _tanggal.text,
        norm: _norm.text,
        kontak: _kontak.text,
        nomorBpjs: _nomorBpjs.text,
        status: widget.data!.status,
      );
      ResponseDb? updateStatusAll = await widget.dbHelper.updateStatus(0, null);
      if (!updateStatusAll!.success) {
        _responseError(updateStatusAll.message);
        setState(() {});
        return;
      }
      ResponseDb? update =
          await widget.dbHelper.updateIdentitas(identitas, widget.data!.id);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (update!.success) {
        setState(() {
          _loadingSave = false;
        });
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        _responseSuccess(update);
      } else {
        setState(() {
          _loadingSave = false;
        });
        await Future.delayed(
          const Duration(milliseconds: 600),
        );
        _responseError(update.message);
      }
    }
  }

  void _responseSuccess(ResponseDb? data) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _successSave(context, data);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<IdentitasPasienSql>;
        Future.delayed(const Duration(milliseconds: 600), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _responseError(String? message) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _errorSave(context, message);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      Future.delayed(
          const Duration(milliseconds: 500), () => Navigator.pop(context));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nik.dispose();
    _nikFocus.dispose();
    _norm.dispose();
    _nama.dispose();
    _tanggal.dispose();
    _nomorBpjs.dispose();
    _kontak.dispose();
    _nomorBpjs.removeListener(_nomorBpjsListen);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        _formIdentitas(context),
        if (_loadingSave)
          Container(
            color: Colors.black54,
            child: const Center(
              child: LoadingWidget(height: 150),
            ),
          ),
      ],
    );
  }

  Widget _formIdentitas(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        constraints:
            BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Text(
                'Form Identitas Pasien Lama',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(
              height: 25.0,
            ),
            Flexible(
              child: ListView(
                controller: _sc,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 18.0),
                shrinkWrap: true,
                children: [
                  InputFormField(
                    controller: _nik,
                    focusNode: _nikFocus,
                    label: 'NIK',
                    hint: 'Ketikkan nomor identitas',
                    counterText: '$_nikLength/16',
                    counterStyle: TextStyle(
                        color: _nikLength == 16 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    charLengthValidate: true,
                    charLength: 16,
                    onChanged: (val) {
                      _nikLength = val.length;
                      setState(() {});
                    },
                  ),
                  if (widget.jenis == 2)
                    const SizedBox(
                      height: 25.0,
                    ),
                  if (widget.jenis == 2)
                    InputFormField(
                      controller: _norm,
                      label: 'Norm',
                      hint: 'Ketikkan nomor rekam medis',
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  InputFormField(
                    controller: _nama,
                    label: 'Nama',
                    hint: 'Ketikkan nama sesuai identitas',
                    readOnly: widget.jenis == 2 ? true : false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  DateFormField(
                    controller: _tanggal,
                    label: 'Tanggal lahir',
                    hint: 'Ketikkan tanggal lahir sesuai identitas',
                    disable: widget.jenis == 2 ? true : false,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  InputFormField(
                    controller: _kontak,
                    label: 'Nomor kontak',
                    hint: 'Ketikkan nomor kontak aktif saat ini',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  InputFormField(
                    controller: _nomorBpjs,
                    label: 'Nomor Kartu BPJS',
                    hint: 'Ketikkan nomor kartu bpjs',
                    validate: false,
                    charLength: _bpjsLength,
                    charLengthValidate: false,
                    counterText: '$_bpjsLength/13',
                    counterStyle: TextStyle(
                        color: _bpjsLength == 13 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ElevatedButton(
                      onPressed: widget.data == null ? _simpan : _update,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: kPrimaryColor),
                      child: widget.data == null
                          ? const Text('SIMPAN')
                          : const Text('UPDATE'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _successSave(BuildContext context, ResponseDb? data) {
    return ResponseModalBottom(
      image: 'images/ok.png',
      title: '${data?.message}',
      message:
          'Identitas ini dapat digunakan saat akan melakukan kunjungan dengan pasien yang sama',
      button: ElevatedButton(
        onPressed: () => Navigator.pop(
          context,
          data?.data,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: kPrimaryColor,
        ),
        child: const Text('Tutup'),
      ),
    );
  }

  Widget _errorSave(BuildContext context, String? message) {
    return ResponseModalBottom(
      image: 'images/sorry.png',
      title: 'Peringatan',
      message: '$message',
    );
  }
}
