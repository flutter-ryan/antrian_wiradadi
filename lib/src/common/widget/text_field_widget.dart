import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final String label;
  final Icon icon;
  final FocusNode focus;
  final TextInputAction inputAction;

  const TextFieldWidget({
    Key key,
    this.hint,
    this.label,
    this.icon,
    this.focus,
    this.inputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: TextField(
        focusNode: focus,
        style: TextStyle(fontSize: 14.0),
        textInputAction: inputAction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
          prefixIcon: icon,
          hintText: '$hint',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: BorderSide(color: kSecondaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
