import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorCreateAntrianWidget extends StatelessWidget {
  final String image;
  final String title;
  final String message;

  const ErrorCreateAntrianWidget({
    Key key,
    this.image,
    this.title,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: SizeConfig.screenWidth,
          constraints: BoxConstraints(minHeight: 100.0),
          margin: EdgeInsets.symmetric(horizontal: 32.0),
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('$image')),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                '$title',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '$message',
                style: TextStyle(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 32.0,
              ),
              Container(
                width: 150,
                height: 45,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  child: Text('Coba lagi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
