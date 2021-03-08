import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/ui/new_body_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/new_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
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
    );
  }
}
