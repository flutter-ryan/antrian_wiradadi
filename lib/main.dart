import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/ui/onboarding_page.dart';
import 'package:antrian_wiradadi/src/common/ui/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSU Wiradadi Husada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
        primaryColor: kSecondaryColor,
        accentColor: kSecondaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('id'),
      ],
      home: Splashpage(),
    );
  }
}
