import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormField extends StatelessWidget {
  const InputFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.validate = true,
    this.counterText,
    this.onChanged,
    this.counterStyle,
    this.charLengthValidate = false,
    this.charLength = 0,
    this.readOnly = false,
    this.autofocus = false,
    this.buttonSearch,
    this.focusNode,
    this.isPhone = false,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool validate;
  final String? counterText;
  final Function(String val)? onChanged;
  final TextStyle? counterStyle;
  final bool charLengthValidate;
  final int charLength;
  final bool readOnly;
  final bool autofocus;
  final Widget? buttonSearch;
  final FocusNode? focusNode;
  final bool isPhone;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
        ),
        const SizedBox(
          height: 12.0,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[400]!, width: 0.6),
                ),
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  autofocus: autofocus,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    counterText: counterText,
                    counterStyle: counterStyle,
                  ),
                  textCapitalization: textCapitalization,
                  textInputAction: textInputAction,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  validator: (value) {
                    if (value!.isEmpty && validate) {
                      return 'Input required';
                    }
                    if (value.characters.length < charLength &&
                        charLengthValidate) {
                      return 'Invalid character length';
                    }
                    if (isPhone) {
                      String pattern =
                          r'(^[0-9]{14}|[0-9]{13}|[0-9]{12}|[0-9]{11}|[0-9]{10}|[0-9]{9}|[0-9]{8}$)';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter valid mobile number';
                      }
                      return null;
                    }
                    return null;
                  },
                  onChanged: onChanged,
                ),
              ),
            ),
            if (buttonSearch != null)
              const SizedBox(
                width: 8,
              ),
            if (buttonSearch != null) buttonSearch!,
          ],
        ),
      ],
    );
  }
}
