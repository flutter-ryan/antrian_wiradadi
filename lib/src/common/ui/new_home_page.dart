import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/ui/new_body_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/new_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  DateTime currentBackPressTime;
  TutorialCoachMark _tutorialCoachMark;
  List<TargetFocus> _targets = [];

  void showTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      context,
      targets: _targets,
      colorShadow: Colors.black,
      textSkip: "Close",
      paddingFocus: 5,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  Future<bool> willPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      Toast.show(
        "Tap sekali lagi untuk keluar",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black87,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = 290.0;
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: willPop,
        child: Scaffold(
          body: Stack(
            children: [
              NewHeaderWidget(
                height: bodyHeight,
                targets: _targets,
                showTutorial: showTutorial,
              ),
              NewBodyWidget(
                height: bodyHeight,
                targets: _targets,
              )
            ],
          ),
        ),
      ),
    );
  }
}
