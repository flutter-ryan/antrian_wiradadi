import 'package:flutter/material.dart';

class ErrorJadwalWidget extends StatelessWidget {
  final String message;
  final String image;
  final Widget button;

  const ErrorJadwalWidget({
    Key key,
    this.image,
    this.message,
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('$image'),
            ),
          ),
        ),
        SizedBox(
          height: 22.0,
        ),
        Text(
          '$message',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(
          height: 22.0,
        ),
        button,
      ],
    );
  }
}
