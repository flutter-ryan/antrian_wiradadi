import 'package:flutter/material.dart';

class SelectFormField extends StatelessWidget {
  const SelectFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.validate = true,
    this.onTap,
    this.readOnly = true,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool validate;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool readOnly;

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!, width: 0.6),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              suffixIcon: suffixIcon,
            ),
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            readOnly: readOnly,
            keyboardType: keyboardType,
            validator: (value) {
              if (value!.isEmpty && validate) {
                return 'Input required';
              }
              return null;
            },
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
