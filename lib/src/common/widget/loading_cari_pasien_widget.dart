import 'package:flutter/material.dart';

class LoadingCariPasienWidget extends StatelessWidget {
  final String message;

  const LoadingCariPasienWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 22.0,
        ),
        Text(
          message,
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        )
      ],
    );
  }
}
