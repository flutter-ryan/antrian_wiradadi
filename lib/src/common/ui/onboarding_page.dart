import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/ui/home_page.dart';
import 'package:flutter/material.dart';

class Onboardingpage extends StatefulWidget {
  @override
  _OnboardingpageState createState() => _OnboardingpageState();
}

class _OnboardingpageState extends State<Onboardingpage> {
  final List<Widget> _introList = <Widget>[
    ScreenIntro(
      image: 'assets/images/onboarding_1.png',
      title: 'Temukan Doktermu',
      subtitle:
          'Tersedia informasi tentang nama dan jadwal dokter pada setiap poliklinik',
    ),
    ScreenIntro(
      image: 'assets/images/onboarding_3.png',
      title: 'Pilih Jadwal Sendiri',
      subtitle: 'Pilih tanggal sesuai jadwal dokter yang tersedia',
    ),
    ScreenIntro(
      image: 'assets/images/onboarding_1.png',
      title: 'Tidak Perlu Antri',
      subtitle: 'Anda tidak perlu lagi antri saat pendaftaran diloket',
    ),
  ];
  PageController controller = PageController();
  int currentPageValue = 0;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: _introList.length,
              onPageChanged: (int page) {
                getChangedPageAndMoveBar(page);
              },
              controller: controller,
              itemBuilder: (context, index) {
                return _introList[index];
              },
            ),
            Container(
              width: SizeConfig.screenWidth,
              height: 35.0,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < _introList.length; i++)
                            if (i == currentPageValue) ...[circleBar(true)] else
                              circleBar(false),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Visibility(
                      visible: currentPageValue == _introList.length - 1
                          ? true
                          : false,
                      child: FlatButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            SlideLeftRoute(
                              page: Homepage(),
                            ),
                            (route) => false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Mulai'),
                            SizedBox(
                              width: 4.0,
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 18.0,
                            ),
                          ],
                        ),
                      ),
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

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 11 : 8,
      width: isActive ? 11 : 8,
      decoration: BoxDecoration(
        color: isActive ? kSecondaryColor : Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class ScreenIntro extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const ScreenIntro({
    Key key,
    this.title,
    this.subtitle,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          height: SizeConfig.blockSizeVertical * 30,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('$image'),
          )),
        ),
        SizedBox(
          height: 52.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            '$subtitle',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
