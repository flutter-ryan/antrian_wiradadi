import 'package:antrian_wiradadi/src/bloc/pendaftaran_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/rujukan_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/create_tiket_antrian_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/dialog_error_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/input_text.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/input_text_date.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/input_text_select.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/rujukan_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PasienBaruFormWidget extends StatefulWidget {
  const PasienBaruFormWidget({
    Key? key,
    required this.pendaftaranPasienBloc,
    this.namaDokter,
    this.jamJadwal,
    this.ruangan,
    this.tanggal,
  }) : super(key: key);

  final PendaftaranPasienBloc pendaftaranPasienBloc;
  final String? namaDokter;
  final String? jamJadwal;
  final String? ruangan;
  final String? tanggal;

  @override
  State<PasienBaruFormWidget> createState() => _PasienBaruFormWidgetState();
}

class _PasienBaruFormWidgetState extends State<PasienBaruFormWidget> {
  final TokenBloc _tokenBloc = TokenBloc();
  final TextEditingController _nikCon = TextEditingController();
  final TextEditingController _namaCon = TextEditingController();
  final TextEditingController _tanggalLahirCon = TextEditingController();
  final TextEditingController _nomorCon = TextEditingController();
  final TextEditingController _caraBayarCon = TextEditingController();
  final TextEditingController _nomorKartuCon = TextEditingController();
  final TextEditingController _noRefCon = TextEditingController();
  final FocusNode _nikFocus = FocusNode();
  final FocusNode _namaFocus = FocusNode();
  final FocusNode _tanggalLahirFocus = FocusNode();
  final FocusNode _nomorFocus = FocusNode();
  final FocusNode _caraBayarFocus = FocusNode();
  final FocusNode _tujuanFocus = FocusNode();
  final FocusNode _nomorKartuFocus = FocusNode();
  final FocusNode _noRefFocus = FocusNode();

  bool _isBpjs = false;

  @override
  void initState() {
    super.initState();
    widget.pendaftaranPasienBloc.normSink.add('0');
    widget.pendaftaranPasienBloc.jenisSink.add('2');
  }

  void _createAntrian() {
    _tokenBloc.getToken();
    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: _streamTokenWidget(context),
              ),
              Positioned(
                top: 3.0,
                right: 2.0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[400],
                  ),
                ),
              )
            ],
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _showRujukan() {
    if (_nomorKartuCon.text.isNotEmpty) {
      _tokenBloc.getToken();
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: _streamTokenRujukan(context),
          );
        },
        duration: const Duration(milliseconds: 500),
        animationType: DialogTransitionType.slideFromBottomFade,
      ).then((value) {
        if (value != null) {
          var nomor = value as String;
          _noRefCon.text = nomor;
          setState(() {});
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Silahkan menginput Nomor BPJS Anda',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
      );
    }
  }

  @override
  void dispose() {
    _nikCon.dispose();
    _namaCon.dispose();
    _tanggalLahirCon.dispose();
    _nomorCon.dispose();
    _caraBayarCon.dispose();
    _nomorKartuCon.dispose();
    _nikFocus.dispose();
    _namaFocus.dispose();
    _tanggalLahirFocus.dispose();
    _nomorFocus.dispose();
    _caraBayarFocus.dispose();
    _tujuanFocus.dispose();
    _nomorKartuFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: ListTile(
            isThreeLine: true,
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'images/avatar-user.png',
              ),
            ),
            title: Text(
              widget.namaDokter!,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  widget.ruangan!,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  '${widget.tanggal} / ${widget.jamJadwal}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          child: Column(
            children: [
              InputText(
                label: 'NIK',
                textCon: _nikCon,
                textFocus: _nikFocus,
                nextFocus: _namaFocus,
                focus: true,
                isNik: true,
                keyAction: TextInputAction.next,
                keyType: TextInputType.number,
                sink: widget.pendaftaranPasienBloc.nikSink,
                stream: widget.pendaftaranPasienBloc.nikStream,
              ),
              const SizedBox(
                height: 28.0,
              ),
              InputText(
                label: 'Nama pasien',
                textCon: _namaCon,
                textFocus: _namaFocus,
                nextFocus: _tanggalLahirFocus,
                keyAction: TextInputAction.next,
                textCap: TextCapitalization.words,
                sink: widget.pendaftaranPasienBloc.namaSink,
                stream: widget.pendaftaranPasienBloc.namaStream,
              ),
              const SizedBox(
                height: 28.0,
              ),
              InputTextDate(
                label: 'Tanggal lahir',
                textCon: _tanggalLahirCon,
                textFocus: _tanggalLahirFocus,
                nextFocus: _nomorFocus,
                keyAction: TextInputAction.next,
                jenis: 'lahir',
                sink: widget.pendaftaranPasienBloc.tanggalLahirSink,
                stream: widget.pendaftaranPasienBloc.tanggalLahirstream,
                getDate: (String? date) {},
              ),
              const SizedBox(
                height: 28.0,
              ),
              InputText(
                label: 'Nomor Kontak',
                textCon: _nomorCon,
                textFocus: _nomorFocus,
                nextFocus: _caraBayarFocus,
                keyAction: TextInputAction.next,
                sink: widget.pendaftaranPasienBloc.contactSink,
                stream: widget.pendaftaranPasienBloc.contactStream,
                keyType: TextInputType.phone,
              ),
              const SizedBox(
                height: 28.0,
              ),
              InputTextSelect(
                label: 'Cara Bayar',
                textCon: _caraBayarCon,
                textFocus: _caraBayarFocus,
                nextFocus: _isBpjs ? _nomorKartuFocus : _tujuanFocus,
                jenis: 'caraBayar',
                keyAction: TextInputAction.next,
                sink: widget.pendaftaranPasienBloc.caraBayarSink,
                stream: widget.pendaftaranPasienBloc.caraBayarStream,
                getId: (String id) {
                  if (id == '2') {
                    widget.pendaftaranPasienBloc.noKartuSink.add('0');
                    widget.pendaftaranPasienBloc.noRefSink.add('0');
                    _nomorKartuCon.clear();
                    _noRefCon.clear();
                    setState(() {
                      _isBpjs = true;
                    });
                  } else {
                    widget.pendaftaranPasienBloc.noKartuSink.add('1');
                    widget.pendaftaranPasienBloc.noRefSink.add('1');
                    _nomorKartuCon.clear();
                    _noRefCon.clear();
                    setState(() {
                      _isBpjs = false;
                    });
                  }
                },
              ),
              _isBpjs
                  ? const SizedBox(
                      height: 28.0,
                    )
                  : const SizedBox(),
              _isBpjs
                  ? InputText(
                      label: 'Nomor Kartu',
                      textCon: _nomorKartuCon,
                      textFocus: _nomorKartuFocus,
                      nextFocus: _noRefFocus,
                      keyAction: TextInputAction.next,
                      keyType: TextInputType.number,
                      sink: widget.pendaftaranPasienBloc.noKartuSink,
                      stream: widget.pendaftaranPasienBloc.noKartuStream,
                      isBpjs: true,
                      isScan: true,
                    )
                  : const SizedBox(),
              _isBpjs
                  ? const SizedBox(
                      height: 28.0,
                    )
                  : const SizedBox(),
              _isBpjs
                  ? InputText(
                      label: 'Nomor Rujukan',
                      textCon: _noRefCon,
                      textFocus: _noRefFocus,
                      nextFocus: _tujuanFocus,
                      isBpjs: true,
                      isRujukan: true,
                      keyType: TextInputType.text,
                      keyAction: TextInputAction.next,
                      sink: widget.pendaftaranPasienBloc.noRefSink,
                      stream: widget.pendaftaranPasienBloc.noRefStream,
                      isSuffix: true,
                      suffixIcon: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: _showRujukan,
                          color: Colors.grey,
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    )
                  : const SizedBox(),
              // bottom space for stack button
              SizedBox(
                height: SizeConfig.blockSizeVertical * 5,
              ),
              StreamSubmit(
                pendaftaranPasienBloc: widget.pendaftaranPasienBloc,
                isBpjs: _isBpjs,
                createAntrian: _createAntrian,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 32.0,
        )
      ],
    );
  }

  Widget _streamTokenWidget(BuildContext context) {
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
              if (snapshot.data!.data!.metadata!.code != 200) {
                return StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return CreateTiketAntrianWidget(
                token: snapshot.data!.data!.response!.token!,
                pendaftaranPasienBloc: widget.pendaftaranPasienBloc,
                jenis: 'Pasien baru',
              );
          }
        }
        return const Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    );
  }

  Widget _streamTokenRujukan(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/loading_transparent.gif'),
                        ),
                      ),
                    ),
                    Text(snapshot.data!.message)
                  ],
                ),
              );
            case Status.error:
              return DialogErrorWidget(
                imageSrc: 'images/server_error_1.png',
                message: snapshot.data!.message,
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code == 500) {
                return DialogErrorWidget(
                  imageSrc: 'images/server_error_1.png',
                  message: snapshot.data!.data!.metadata!.message!,
                );
              }
              return ListRujukan(
                token: snapshot.data!.data!.response!.token!,
                noBpjs: _nomorKartuCon.text,
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

class StreamSubmit extends StatefulWidget {
  const StreamSubmit({
    Key? key,
    required this.pendaftaranPasienBloc,
    required this.isBpjs,
    required this.createAntrian,
  }) : super(key: key);

  final PendaftaranPasienBloc pendaftaranPasienBloc;
  final bool isBpjs;
  final Function() createAntrian;

  @override
  State<StreamSubmit> createState() => _StreamSubmitState();
}

class _StreamSubmitState extends State<StreamSubmit> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.isBpjs
          ? widget.pendaftaranPasienBloc.submitBaruKartu
          : widget.pendaftaranPasienBloc.submitBaru,
      builder: (context, snapshot) => SizedBox(
        width: SizeConfig.blockSizeHorizontal * 60,
        height: 48,
        child: TextButton(
          onPressed: snapshot.hasData ? widget.createAntrian : null,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            backgroundColor:
                snapshot.hasData ? kSecondaryColor : Colors.grey[200],
          ),
          child: const Text('DAFTAR SEKARANG'),
        ),
      ),
    );
  }
}

class ListRujukan extends StatefulWidget {
  const ListRujukan({
    super.key,
    required this.token,
    required this.noBpjs,
  });

  final String token;
  final String noBpjs;

  @override
  State<ListRujukan> createState() => _ListRujukanState();
}

class _ListRujukanState extends State<ListRujukan> {
  final _rujukanBloc = RujukanBloc();

  @override
  void initState() {
    super.initState();
    getRujukan();
  }

  void getRujukan() {
    _rujukanBloc.tokenSink.add(widget.token);
    _rujukanBloc.faskesSink.add(2);
    _rujukanBloc.noKartuSink.add(widget.noBpjs);
    _rujukanBloc.getRujukan();
  }

  @override
  void dispose() {
    _rujukanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<RujukanModel>>(
      stream: _rujukanBloc.rujukanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/loading_transparent.gif'),
                        ),
                      ),
                    ),
                    Text(snapshot.data!.message)
                  ],
                ),
              );
            case Status.error:
              return DialogErrorWidget(
                imageSrc: 'images/server_error_1.png',
                message: snapshot.data!.message,
                buttonRetry: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(150, 42),
                  ),
                  child: const Text('Tutup'),
                ),
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return SecondStreamRujukan(
                  token: widget.token,
                  noKartu: widget.noBpjs,
                );
              }
              return StreamResultRujukan(
                data: snapshot.data!.data!.data!.rujukan,
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

class SecondStreamRujukan extends StatefulWidget {
  const SecondStreamRujukan({
    super.key,
    this.noKartu,
    this.token,
  });

  final String? noKartu;
  final String? token;

  @override
  State<SecondStreamRujukan> createState() => _SecondStreamRujukanState();
}

class _SecondStreamRujukanState extends State<SecondStreamRujukan> {
  final _rujukanBloc = RujukanBloc();

  @override
  void initState() {
    super.initState();
    _getRujukanSecondary();
  }

  void _getRujukanSecondary() {
    _rujukanBloc.tokenSink.add(widget.token!);
    _rujukanBloc.noKartuSink.add(widget.noKartu!);
    _rujukanBloc.faskesSink.add(1);
    _rujukanBloc.getRujukan();
  }

  @override
  void dispose() {
    _rujukanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<RujukanModel>>(
      stream: _rujukanBloc.rujukanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/loading_transparent.gif'),
                        ),
                      ),
                    ),
                    Text(snapshot.data!.message)
                  ],
                ),
              );
            case Status.error:
              return DialogErrorWidget(
                imageSrc: 'images/server_error_1.png',
                message: snapshot.data!.message,
                buttonRetry: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(150, 42),
                  ),
                  child: const Text('Tutup'),
                ),
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return DialogErrorWidget(
                  imageSrc: 'images/server_error_1.png',
                  message: 'Data rujukan tidak tersedia',
                  buttonRetry: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(150, 42),
                    ),
                    child: const Text('Tutup'),
                  ),
                );
              }
              return StreamResultRujukan(
                data: snapshot.data!.data!.data!.rujukan,
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

class StreamResultRujukan extends StatefulWidget {
  const StreamResultRujukan({
    super.key,
    this.data,
  });

  final List<Rujukan>? data;

  @override
  State<StreamResultRujukan> createState() => _StreamResultRujukanState();
}

class _StreamResultRujukanState extends State<StreamResultRujukan> {
  final _tanggal = DateFormat('dd MMM yyyy', 'id');
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
          child: Text(
            'Daftar Rujukan',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(
          height: 0.0,
        ),
        ListView.separated(
          padding: const EdgeInsets.only(bottom: 22.0),
          shrinkWrap: true,
          itemBuilder: (context, i) {
            var data = widget.data![i];
            return ListTile(
              onTap: () => Navigator.pop(context, data.noKunjungan),
              title: Text(
                _tanggal.format(data.tglKunjungan!),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                  '${data.peserta!.nama} / ${data.poliRujukan!.nama} / ${data.noKunjungan}'),
            );
          },
          separatorBuilder: (context, i) => const Divider(),
          itemCount: widget.data!.length,
        ),
      ],
    );
  }
}
