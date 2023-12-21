import 'dart:io';

import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/confg/transition/slide_left_route.dart';
import 'package:antrian_wiradadi/src/pages/components/input_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/new_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _nama = TextEditingController();
  String? panggilan;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _checkUpdate();
    _getNickname();
  }

  void _getNickname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    panggilan = prefs.getString('nama');
  }

  void _nextPage() {
    if (panggilan == null) {
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: _formPanggilanWidget(context),
          );
        },
        duration: const Duration(milliseconds: 500),
      ).then((value) {
        if (value != null) {
          setState(() {
            _loading = true;
          });
          _simpan();
        }
      });
      return;
    }
    _navigate();
  }

  void _simpan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nama', _nama.text);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _loading = false;
      });
      _navigate();
    });
  }

  void _checkUpdate() {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().then((_) {
            //
          }).catchError((e) {
            Fluttertoast.showToast(
              msg: e.toString(),
            );
          });
          return;
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
      return;
    }
  }

  void _navigate() {
    Navigator.pushAndRemoveUntil(
      context,
      SlideLeftRoute(
        page: NewHomePage(
          nama: panggilan ?? _nama.text,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[50],
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 120,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: kBackgroundLogo,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          'Pendaftaran Antrian',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const Text(
                          namaRs,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          'Selamat datang di Aplikasi pendaftaran antrian mandiri $namaRs',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Expanded(
                      child: Image.asset('images/hat.png'),
                    ),
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        backgroundColor: kPrimaryColor,
                      ),
                      child: const Text('Daftar Sekarang'),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    const Text(
                      'Tap Daftar Sekarang untuk melanjutkan pendaftaran antrian Anda',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: LoadingWidget(
                    height: 120,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _formPanggilanWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagaimana kami harus menyapa Anda?',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12.0,
          ),
          InputFormField(
            controller: _nama,
            label: 'Nama',
            hint: 'Ketikkan nama untuk memanggilmu',
            autofocus: true,
          ),
          const SizedBox(
            height: 22.0,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'simpan'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: kPrimaryDarkColor),
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }
}
