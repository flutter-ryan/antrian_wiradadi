import 'package:flutter/material.dart';

class LoadingTempatTidurWidget extends StatelessWidget {
  final String message;

  const LoadingTempatTidurWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/create_loading.gif')),
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
        Text(
          '$message',
          style: TextStyle(
              fontSize: 18.0, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
