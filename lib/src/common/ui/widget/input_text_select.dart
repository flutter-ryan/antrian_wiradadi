import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:antrian_wiradadi/src/bloc/cara_bayar_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/dialog_error_widget.dart';
import 'package:antrian_wiradadi/src/models/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InputTextSelect extends StatefulWidget {
  const InputTextSelect({
    Key? key,
    required this.label,
    required this.textCon,
    required this.textFocus,
    required this.sink,
    required this.stream,
    this.nextFocus,
    this.keyAction = TextInputAction.next,
    this.jenis,
    this.pos,
    this.tanggalPoli,
    this.getId,
    this.poliBpjs,
    this.getPoliBpjs,
    this.isKunjungan = false,
    this.isPoliBpjs = false,
  }) : super(key: key);

  final String label;
  final TextEditingController textCon;
  final FocusNode textFocus;
  final FocusNode? nextFocus;
  final TextInputAction keyAction;
  final String? jenis;
  final String? pos;
  final StreamSink<dynamic> sink;
  final Stream<dynamic> stream;
  final String? poliBpjs;
  final String? tanggalPoli;
  final bool isKunjungan;
  final bool isPoliBpjs;
  final Function(String id)? getId;
  final Function(String? poliBpjs)? getPoliBpjs;

  @override
  State<InputTextSelect> createState() => _InputTextSelectState();
}

class _InputTextSelectState extends State<InputTextSelect> {
  final AnimateIconController _animateIconController = AnimateIconController();
  final TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    widget.textFocus.addListener(_focusListener);
  }

  void _focusListener() {
    if (widget.textFocus.hasFocus) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _showDialogStream(),
      );
    }
  }

  void _showDialogStream() {
    if (widget.jenis == 'dokter' && !widget.isPoliBpjs) {
      Fluttertoast.showToast(
        msg: 'Pilih poliklinik',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    } else if (widget.jenis == 'dokter' && !widget.isKunjungan) {
      Fluttertoast.showToast(
        msg: 'Pilih tanggal kunjungan',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    _tokenBloc.getToken();
    _animateIconController.animateToEnd();
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: _streamTokenSelect(context),
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      _animateIconController.animateToStart();
      if (widget.nextFocus != null && value != null) {
        FocusScope.of(context).requestFocus(widget.nextFocus);
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1,
          style: BorderStyle.solid,
          color: Colors.blueGrey[900]!.withAlpha(80),
        ),
      ),
      child: StreamBuilder<dynamic>(
        stream: widget.stream,
        builder: (context, snapshot) => TextField(
          controller: widget.textCon,
          focusNode: widget.textFocus,
          style: const TextStyle(
            color: Colors.black,
          ),
          readOnly: true,
          textInputAction: widget.keyAction,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(color: Colors.blueGrey[900]!.withAlpha(200)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: AnimateIcons(
              startIconColor: Colors.blueGrey[900]!.withAlpha(80),
              endIconColor: Colors.blueGrey[900]!.withAlpha(80),
              startIcon: Icons.expand_more_rounded,
              endIcon: Icons.expand_less_rounded,
              duration: const Duration(milliseconds: 300),
              onStartIconPress: () {
                _showDialogStream();
                return false;
              },
              onEndIconPress: () {
                Navigator.pop(context);
                return false;
              },
              controller: _animateIconController,
            ),
          ),
        ),
      ),
    );
  }

  Widget _streamTokenSelect(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: StreamBuilder<ApiResponse<TokenResponseModel>>(
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
                  imageSrc: 'images/server_error.png',
                  message: snapshot.data!.message,
                );
              case Status.completed:
                if (snapshot.data!.data!.metadata!.code == 500) {
                  return DialogErrorWidget(
                    imageSrc: 'images/server_error_1.png',
                    message: snapshot.data!.data!.metadata!.message!,
                  );
                }
                return StreamCaraBayar(
                  token: snapshot.data!.data!.response!.token!,
                  caraBayar: (String id, String cara) {
                    widget.textCon.text = cara;
                    widget.sink.add(id);
                    widget.getId!(id);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context, 'selected');
                    });
                  },
                );
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
          );
        },
      ),
    );
  }
}

class StreamCaraBayar extends StatefulWidget {
  const StreamCaraBayar({
    Key? key,
    required this.token,
    required this.caraBayar,
  }) : super(key: key);

  final String token;
  final Function(String id, String cara) caraBayar;

  @override
  State<StreamCaraBayar> createState() => _StreamCaraBayarState();
}

class _StreamCaraBayarState extends State<StreamCaraBayar> {
  final CaraBayarBloc _caraBayarBloc = CaraBayarBloc();
  final TextEditingController _filterCon = TextEditingController();
  String _filter = '';
  List<CaraBayar> listCaraBayar = [];
  String? desc;

  @override
  void initState() {
    super.initState();
    _caraBayarBloc.tokenSink.add(widget.token);
    _caraBayarBloc.getCaraBayar();
    _filterCon.addListener(() {
      setState(() {
        _filter = _filterCon.text;
      });
    });
  }

  void _pilihCaraBayar(String id, String deskripsi) {
    widget.caraBayar(id, deskripsi);
    setState(() {
      desc = deskripsi;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<CaraBayarModel>>(
      stream: _caraBayarBloc.caraBayarStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                imageSrc: 'images/server_error.png',
                message: snapshot.data!.message,
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return const DialogErrorWidget(
                  imageSrc: 'images/server_error_1.png',
                  message: 'No Data Found',
                );
              }
              if (_filter == '') {
                listCaraBayar = snapshot.data!.data!.caraBayar!;
              } else {
                listCaraBayar = snapshot.data!.data!.caraBayar!
                    .where(
                      (element) => element.deskripsi!.toLowerCase().contains(
                            _filter.toLowerCase(),
                          ),
                    )
                    .toList();
              }
              return Container(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.blockSizeVertical * 70,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      padding: const EdgeInsets.fromLTRB(22.0, 12.0, 8.0, 12.0),
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0),
                        ),
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cara bayar',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              desc != null
                                  ? Text('$desc',
                                      style: TextStyle(color: Colors.grey[200]))
                                  : Text(
                                      'Tap salah satu',
                                      style: TextStyle(color: Colors.grey[200]),
                                    ),
                            ],
                          ),
                          Material(
                            color: Colors.transparent,
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
                    ),
                    const Divider(
                      height: 0.0,
                      thickness: 0.5,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            margin: const EdgeInsets.all(15.0),
                            height: 48.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(52.0),
                            ),
                            child: TextField(
                              controller: _filterCon,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Pencarian',
                                suffixIcon: _filter == ''
                                    ? null
                                    : IconButton(
                                        onPressed: () => _filterCon.clear(),
                                        color: Colors.grey[400],
                                        icon: const Icon(Icons.close),
                                      ),
                              ),
                            ),
                          ),
                          listCaraBayar.isEmpty
                              ? const DialogErrorWidget(
                                  imageSrc: 'images/server_error_1.png',
                                  message: 'No Data Found',
                                )
                              : Flexible(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(
                                        bottom: 18.0, top: 0.0),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, i) {
                                      return Divider(
                                        height: 0.0,
                                        color: Colors.grey[400],
                                      );
                                    },
                                    itemCount: listCaraBayar.length,
                                    itemBuilder: (context, i) {
                                      CaraBayar data = listCaraBayar[i];
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 28.0),
                                        title: Text('${data.deskripsi}'),
                                        onTap: () => _pilihCaraBayar(
                                            data.id!, data.deskripsi!),
                                        trailing: data.deskripsi == desc
                                            ? const Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.green,
                                              )
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    );
  }
}
