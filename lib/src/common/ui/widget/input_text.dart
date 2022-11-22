import 'dart:async';

import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:scan/scan.dart';

class InputText extends StatefulWidget {
  const InputText({
    Key? key,
    required this.label,
    required this.textCon,
    required this.textFocus,
    this.nextFocus,
    this.sink,
    this.stream,
    this.focus = false,
    this.keyType = TextInputType.text,
    this.keyAction = TextInputAction.next,
    this.textCap = TextCapitalization.sentences,
    this.isScan = false,
    this.isReadonly = false,
    this.hint,
    this.isNik = false,
    this.isBpjs = false,
    this.isRujukan = false,
    this.isSuffix = false,
    this.suffixIcon,
  }) : super(key: key);

  final String label;
  final TextEditingController textCon;
  final FocusNode textFocus;
  final FocusNode? nextFocus;
  final bool focus;
  final TextInputType keyType;
  final TextInputAction keyAction;
  final TextCapitalization textCap;
  final StreamSink<String>? sink;
  final Stream<String>? stream;
  final bool isScan;
  final bool isReadonly;
  final String? hint;
  final bool isNik;
  final bool isBpjs;
  final bool isRujukan;
  final Widget? suffixIcon;
  final bool isSuffix;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final ScanController _scanController = ScanController();
  int _charLength = 0;

  @override
  void initState() {
    super.initState();
    widget.textCon.addListener(_cekInput);
  }

  void _cekInput() {
    if (widget.textCon.text == '') {
      widget.sink!.add('');
    } else {
      widget.sink!.add(widget.textCon.text);
    }
  }

  void _scanKartu() {
    _scanController.resume();
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (contextDialog) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            width: SizeConfig.screenWidth,
            constraints: BoxConstraints(
              minHeight: SizeConfig.blockSizeVertical * 25,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12.0),
              ],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: SizeConfig.blockSizeVertical * 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: ScanView(
                      controller: _scanController,
                      scanAreaScale: .7,
                      scanLineColor: Colors.green.shade400,
                      onCapture: (data) {
                        widget.textCon.text = data;
                        widget.sink!.add(data);
                        Navigator.pop(contextDialog);
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      'Pindai kode batang pada kartu jaminan kesehatan Anda',
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      _scanController.pause();
      FocusScope.of(context).requestFocus(widget.nextFocus);
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
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<String>(
              stream: widget.stream,
              builder: (context, snapshot) => TextField(
                controller: widget.textCon,
                focusNode: widget.textFocus,
                autofocus: widget.focus,
                style: const TextStyle(color: Colors.black),
                keyboardType: widget.keyType,
                textInputAction: widget.keyAction,
                textCapitalization: widget.textCap,
                readOnly: widget.isReadonly,
                decoration: InputDecoration(
                  labelText: widget.label,
                  floatingLabelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  counterText: widget.isNik || widget.isBpjs
                      ? widget.isNik
                          ? '$_charLength / 16'
                          : widget.isRujukan
                              ? '$_charLength / 19'
                              : '$_charLength / 13'
                      : null,
                  hintText: widget.hint,
                  errorText:
                      snapshot.hasError && (widget.isNik || widget.isBpjs)
                          ? snapshot.error.toString()
                          : null,
                  labelStyle:
                      TextStyle(color: Colors.blueGrey[900]!.withAlpha(200)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: widget.isScan
                      ? IconButton(
                          onPressed: _scanKartu,
                          color: Colors.grey,
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                          ),
                        )
                      : widget.isSuffix
                          ? widget.suffixIcon
                          : const SizedBox(),
                ),
                onChanged: (value) => setState(() {
                  _charLength = value.length;
                }),
                onSubmitted: (value) {
                  if (widget.nextFocus != null) {
                    FocusScope.of(context).requestFocus(widget.nextFocus);
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
