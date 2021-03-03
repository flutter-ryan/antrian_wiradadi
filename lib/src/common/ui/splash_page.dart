import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/ui/home_page.dart';
import 'package:antrian_wiradadi/src/common/ui/new_home_page.dart';
import 'package:antrian_wiradadi/src/common/ui/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class Splashpage extends StatefulWidget {
  @override
  _SplashpageState createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  String version;
  @override
  void initState() {
    super.initState();
    durationSplash();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  void durationSplash() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NewHomePage(),
          ),
          (route) => false),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'logoHero',
                child: Container(
                  width: 180.0,
                  height: 180.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 22.0,
              right: 0.0,
              left: 0.0,
              child: Column(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: animationController.drive(ColorTween(
                          begin: kPrimaryColor, end: kSecondaryColor)),
                    ),
                  ),
                  SizedBox(
                    height: 72.0,
                  ),
                  Text(
                    'From\nSimpel Development',
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Version $version',
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
