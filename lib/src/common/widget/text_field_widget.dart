import 'dart:async';

import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextFieldWidget extends StatefulWidget {
  final String hint;
  final String label;
  final Icon icon;
  final FocusNode focus;
  final TextInputAction inputAction;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isCalendar;
  final Stream stream;
  final StreamSink sink;

  const TextFieldWidget({
    Key key,
    this.hint,
    this.label,
    this.icon,
    this.focus,
    this.inputAction,
    this.controller,
    this.keyboardType,
    this.isCalendar = false,
    this.stream,
    this.sink,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String _selectedDate;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_focusListener);
  }

  void _focusListener() {
    if (widget.isCalendar && widget.focus.hasFocus) {
      _showDatePicker(context);
    }
  }

  Future<Null> _showDatePicker(BuildContext context) async {
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
      FocusScope.of(context).requestFocus(new FocusNode());
    } else {
      widget.focus.unfocus();
      FocusScope.of(context).requestFocus(new FocusNode());
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
        padding: const EdgeInsets.only(top: 22.0, left: 32.0, right: 32.0),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focus,
          style: TextStyle(fontSize: 14.0),
          textInputAction: widget.inputAction,
          keyboardType: widget.keyboardType,
          readOnly: widget.isCalendar,
          onChanged: (value) {
            widget.sink.add(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.0, horizontal: 5.0),
            prefixIcon: widget.icon,
            hintText: '${widget.hint}',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: kSecondaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
