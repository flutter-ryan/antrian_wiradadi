import 'package:flutter/material.dart';

class ErrorCaariPasienWidget extends StatelessWidget {
  final String image, title, message;
  final Widget button;

  const ErrorCaariPasienWidget({
    Key key,
    this.image,
    this.title,
    this.message,
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('$image'),
          )),
        ),
        SizedBox(
          height: 22.0,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
        SizedBox(
          height: 32.0,
        ),
        button,
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
