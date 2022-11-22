import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({Key? key}) : super(key: key);

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  String version = '1.0.0';
  @override
  void initState() {
    super.initState();
    getVersion();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
    Future.delayed(
      const Duration(milliseconds: 3000),
      () => Navigator.pushAndRemoveUntil(
          context,
          SlideLeftRoute(
            page: const Homepage(),
          ),
          (route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: kPrimaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 18.0,
                  children: [
                    Container(
                      height: 160,
                      width: 160,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kBackgroundLogo,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Image.asset('images/logo.png'),
                    ),
                    const Text(
                      namaRs,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 18.0,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kSecondaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Memeriksa versi',
                      style: TextStyle(
                          color: kLightTextColor, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 52.0,
                    ),
                    Text(
                      'From',
                      style: TextStyle(fontSize: 10.0, color: kLightTextColor),
                    ),
                    Text(
                      'Simpel Development',
                      style: TextStyle(fontSize: 12.0, color: kLightTextColor),
                    ),
                    Text(
                      'V.$version',
                      style: TextStyle(fontSize: 10.0, color: kLightTextColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
