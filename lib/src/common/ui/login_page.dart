import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/ui/home_page.dart';
import 'package:antrian_wiradadi/src/common/ui/registrasi_page.dart';
import 'package:antrian_wiradadi/src/common/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: SizeConfig.screenHeight,
              child: Stack(
                children: [
                  Positioned(
                    left: -155,
                    top: 170,
                    child: Transform.rotate(
                      angle: -math.pi / 3.6,
                      child: Container(
                        width: 460,
                        height: 450,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(45.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 28.0,
                                offset: Offset(3.0, 3.0),
                                spreadRadius: 8.0,
                              )
                            ]),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Column(
                      children: [
                        Hero(
                          tag: 'logoHero',
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Antrian Online',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 190),
                    padding: EdgeInsets.only(left: 12.0, right: 32.0),
                    width: SizeConfig.screenWidth,
                    height: 450,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          'RSU Wiradadi Husada',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: kSecondaryColor),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text('Silahkan login untuk melanjutkan'),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 78,
                          child: TextFieldWidget(
                            hint: 'Input nomor KTP',
                            label: 'Nomor KTP',
                            icon: Icon(Icons.credit_card),
                          ),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 78,
                          child: TextFieldWidget(
                            hint: 'Input password',
                            label: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 150.0,
                            height: 42.0,
                            margin: EdgeInsets.only(right: 35.0),
                            child: RaisedButton(
                              onPressed: () => Navigator.pushAndRemoveUntil(
                                  context,
                                  SlideLeftRoute(
                                    page: Homepage(),
                                  ),
                                  (route) => false),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              color: kSecondaryColor,
                              textColor: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('LOGIN'),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 42,
                        ),
                        Row(
                          children: [
                            Text('Belum punya akun?'),
                            SizedBox(
                              width: 7.0,
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Registrasipage(),
                                ),
                              ),
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
