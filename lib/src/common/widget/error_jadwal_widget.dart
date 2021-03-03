import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorJadwalWidget extends StatelessWidget {
  final String message;

  const ErrorJadwalWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(top: 12.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(2.0, -1.0))
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.0), topRight: Radius.circular(22.0))),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0 dokter ditemukan',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                Icon(
                  Icons.segment,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/no_data.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Text(
                  '$message',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
