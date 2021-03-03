import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorPoliWidget extends StatelessWidget {
  final String message;
  final String linkImage;

  const ErrorPoliWidget({
    Key key,
    this.message,
    this.linkImage,
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
              image: AssetImage('$linkImage'),
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
            fontSize: 16.0,
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
