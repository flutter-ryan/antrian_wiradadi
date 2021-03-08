import 'package:flutter/material.dart';

class ErrorTempatTidurWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget child;

  const ErrorTempatTidurWidget({
    Key key,
    this.title,
    this.message,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/server_error.png')),
          ),
        ),
        SizedBox(
          height: 22.0,
        ),
        Text('$title',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic)),
        SizedBox(
          height: 18.0,
        ),
        Text(
          '$message',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
        child,
      ],
    );
  }
}
