import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class Onboardingpage extends StatefulWidget {
  @override
  _OnboardingpageState createState() => _OnboardingpageState();
}

class _OnboardingpageState extends State<Onboardingpage> {
  final List<Widget> _introList = <Widget>[
    ScreenIntro(
      title: 'Temukan Doktermu',
      subtitle:
          'Tersedia informasi tentang nama dan jadwal dokter pada setiap poliklinik',
    ),
    ScreenIntro(
      title: 'Pilih Jadwal Sendiri',
      subtitle: 'Pilih tanggal sesuai jadwal dokter yang tersedia',
    ),
    ScreenIntro(
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
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
                SizedBox(
                  height: 32,
                ),
                Visibility(
                    visible: currentPageValue == _introList.length - 1
                        ? true
                        : false,
                    child: Container(
                      width: 150.0,
                      child: FlatButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        textColor: Colors.white,
                        color: kSecondaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Mulai'),
                            SizedBox(
                              width: 4.0,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 18.0,
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
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
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
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

  const ScreenIntro({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 58,
          ),
          Text(
            '$title',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 18.0,
          ),
          Text(
            '$subtitle',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
