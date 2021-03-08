import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DialogWelcomeWidget extends StatefulWidget {
  final List<TargetFocus> targets;

  const DialogWelcomeWidget({
    Key key,
    this.targets,
  }) : super(key: key);

  @override
  _DialogWelcomeWidgetState createState() => _DialogWelcomeWidgetState();
}

class _DialogWelcomeWidgetState extends State<DialogWelcomeWidget> {
  void _tidak() {
    Navigator.pop(context);
    cekFirstTime();
  }

  void _lanjutkan() {
    Navigator.pop(context);
    showTutorial();
    cekFirstTime();
  }

  void showTutorial() {
    TutorialCoachMark(
      context,
      targets: widget.targets,
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

  cekFirstTime() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String first = _prefs.get('firstTime');
    if (first == null) {
      _prefs.setString('firstTime', 'yes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: 18.0,
                left: 18.0,
                right: 18.0,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/doctor.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Selamat Datang',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                      'Apakah Anda ingin melanjutkan tutorial singkat penggunaan Antrian Online RSU WIRADADI HUSADA?',
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 22.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 45.0,
                            child: TextButton(
                              onPressed: _tidak,
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                              child: Text(
                                'Tidak',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 45.0,
                            child: TextButton(
                              onPressed: _lanjutkan,
                              style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              child: Text(
                                'Ya, Lanjutkan',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: Consts.avatarRadius + Consts.padding - 18,
              right: 1.0,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[500]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                radius: Consts.avatarRadius,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 42.0;
}
