import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  final GlobalKey searchKey;

  const HeaderWidget({
    Key key,
    this.searchKey,
  }) : super(key: key);
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22.0),
          bottomRight: Radius.circular(22.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28.0,
                      ),
                      Text(
                        'Antrian Online',
                        style: TextStyle(
                            fontSize: 22.0,
                            color: kSecondaryColor,
                            fontFamily: 'Nunito'),
                      ),
                      Text(
                        'Pendaftaran Maksimal Pukul 20:00',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 13.0),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/doctor.png'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
