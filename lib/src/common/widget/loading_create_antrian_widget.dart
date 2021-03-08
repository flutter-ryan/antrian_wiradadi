import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class LoadingCreateAntrianWidget extends StatelessWidget {
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
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/create_loading.gif'),
                  ),
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Text(
                'Mohon tunggu',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
              Text(
                'Membuat antrian..',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
