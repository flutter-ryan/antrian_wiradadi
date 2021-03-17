import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorCaraBayarWidget extends StatelessWidget {
  final String message;
  final String image;
  final Widget button;

  const ErrorCaraBayarWidget({
    Key key,
    this.message,
    this.image,
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.blockSizeVertical * 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('$image'),
            )),
          ),
          SizedBox(
            height: 18.0,
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
          SizedBox(
            height: 22.0,
          ),
          button,
        ],
      ),
    );
  }
}
