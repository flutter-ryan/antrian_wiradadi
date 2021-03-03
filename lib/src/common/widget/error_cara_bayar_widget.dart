import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorCaraBayarWidget extends StatelessWidget {
  final String message;

  const ErrorCaraBayarWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/server_error.png'),
            )),
          ),
          Text(
            '$message',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
