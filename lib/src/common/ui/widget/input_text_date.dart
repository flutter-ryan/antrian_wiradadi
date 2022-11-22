import 'dart:async';

import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';

class InputTextDate extends StatefulWidget {
  const InputTextDate({
    Key? key,
    required this.label,
    required this.textCon,
    required this.textFocus,
    this.sink,
    this.stream,
    this.nextFocus,
    this.keyAction = TextInputAction.next,
    this.jenis,
    this.hint,
    this.isReadOnly = false,
    this.getDate,
  }) : super(key: key);

  final String label;
  final TextEditingController textCon;
  final FocusNode textFocus;
  final FocusNode? nextFocus;
  final TextInputAction keyAction;
  final String? jenis;
  final StreamSink<String>? sink;
  final Stream<String>? stream;
  final String? hint;
  final bool isReadOnly;
  final Function? getDate;

  @override
  _InputTextDateState createState() => _InputTextDateState();
}

class _InputTextDateState extends State<InputTextDate> {
  DateTime _selectedDate = DateTime(2000, 1, 1);
  final DateFormat _format = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    super.initState();
    widget.textFocus.addListener(_focusListener);
    widget.textCon.addListener(_cekInput);
  }

  void _cekInput() {
    if (widget.textCon.text == '') {
      widget.sink!.add('');
    } else {
      widget.sink!.add(widget.textCon.text);
    }
  }

  void _focusListener() {
    if (widget.textFocus.hasFocus) {
      if (widget.jenis == 'lahir' && !widget.isReadOnly) {
        _datePickerBirth();
      }
    }
  }

  void _datePickerBirth() async {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kSecondaryColor,
            ),
          ),
          child: DatePickerDialog(
            initialDate: _selectedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            helpText: 'Pilih tanggal lahir',
            cancelText: 'Batal',
            confirmText: 'Pilih',
            fieldLabelText: 'Tanggal lahir',
            fieldHintText: 'Tanggal/Bulan/Tahun',
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 400),
    ).then((value) {
      if (value != null) {
        var picked = value as DateTime;
        setState(() {
          _selectedDate = picked;
          widget.textCon.text = _format.format(picked);
        });
        widget.getDate!(_format.format(picked));
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
      child: StreamBuilder<String>(
        stream: widget.stream,
        builder: (context, snapshot) => TextField(
          controller: widget.textCon,
          focusNode: widget.textFocus,
          style: const TextStyle(
            color: Colors.black,
          ),
          textInputAction: widget.keyAction,
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: snapshot.hasError ? null : null,
            labelStyle: TextStyle(
              color: Colors.grey[900]!.withAlpha(200),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: const Icon(Icons.event_note_rounded),
          ),
        ),
      ),
    );
  }
}
