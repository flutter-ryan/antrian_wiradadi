import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/ui/new_body_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/new_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    double bodyHeight = 340.0;
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Stack(
          children: [
            NewHeaderWidget(
              height: bodyHeight,
            ),
            NewBodyWidget(
              height: bodyHeight,
            )
          ],
        ),
      ),
    );
  }
}
