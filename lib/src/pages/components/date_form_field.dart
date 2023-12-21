import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';

class DateFormField extends StatefulWidget {
  const DateFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.validate = true,
    this.disable = false,
    this.icon,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final bool validate;
  final bool disable;
  final Widget? icon;

  @override
  State<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  DateTime _selectedDate = DateTime(2000, 1, 1);
  final _tanggal = DateFormat('yyyy-MM-dd');

  void _showDate() async {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(const Duration(milliseconds: 600));
    }
    if (!mounted) return;
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
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
          widget.controller!.text = _tanggal.format(picked);
        });
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
        ),
        const SizedBox(
          height: 12.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!, width: 0.6),
          ),
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              suffixIcon: widget.icon,
            ),
            readOnly: true,
            validator: (value) {
              if (value!.isEmpty && widget.validate) {
                return 'Input required';
              }
              return null;
            },
            onTap: widget.disable ? null : _showDate,
          ),
        ),
      ],
    );
  }
}
