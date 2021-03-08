import 'package:antrian_wiradadi/src/bloc/tempat_tidur_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/body_tiket_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/error_tempat_tidur_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/loading_tempat_tidur_widget.dart';
import 'package:antrian_wiradadi/src/model/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NewHeaderWidget extends StatefulWidget {
  final double height;
  final List<TargetFocus> targets;
  final Function showTutorial;

  const NewHeaderWidget({
    Key key,
    this.height,
    this.targets,
    this.showTutorial,
  }) : super(key: key);

  @override
  _NewHeaderWidgetState createState() => _NewHeaderWidgetState();
}

class _NewHeaderWidgetState extends State<NewHeaderWidget> {
  GlobalKey infoTtKey = GlobalKey();
  GlobalKey tiketKey = GlobalKey();
  GlobalKey tutorialKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initTargets();
  }

  void _showTiket() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tiket',
      transitionBuilder: (context, a1, a2, child) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: DialogTiket(),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, a1, a2) {
        return;
      },
    );
  }

  void showSheetBed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      builder: (context) {
        return StreamTempatTidur();
      },
    );
  }

  void _initTargets() {
    widget.targets.add(
      TargetFocus(
        identify: "Info Tempat Tidur",
        keyTarget: infoTtKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Info Ketersedian Tempat Tidur",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap pada icon ini untuk melihat informasi tempat tidur di RSUP Wiradadi Husada",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    widget.targets.add(
      TargetFocus(
        identify: "Info Tiket Antrian",
        keyTarget: tiketKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tunjukkan Tiket Antrian",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap pada icon ini untuk menampilkan tiket Anda kemudian tunjukkan kepada petugas pendaftaran Kami",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    widget.targets.add(
      TargetFocus(
        identify: "Tutorial",
        keyTarget: tutorialKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tutorial penggunaan aplikasi",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap pada icon ini untuk melihat kembali tutorial penggunaan aplikasi antrian online",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_header.jpeg'),
          fit: BoxFit.fill,
          alignment: Alignment.centerLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12.0,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RSU Wiradadi Husada',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.hotel,
                            key: infoTtKey,
                            size: 20.0,
                          ),
                          onPressed: showSheetBed,
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.receipt,
                            key: tiketKey,
                            size: 20,
                          ),
                          onPressed: _showTiket,
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.info,
                            key: tutorialKey,
                            size: 20,
                          ),
                          onPressed: widget.showTutorial,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Antrian Online',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Layanan antrian prioritas memberikan kemudahan tanpa harus mengantri di loket',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: 120,
                    height: 130,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/doctor.png'),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DialogTiket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.0),
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
              child: TiketBodyWidget(),
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
                child: Icon(
                  Icons.receipt,
                  size: 42.0,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamTempatTidur extends StatefulWidget {
  @override
  _StreamTempatTidurState createState() => _StreamTempatTidurState();
}

class _StreamTempatTidurState extends State<StreamTempatTidur> {
  TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 5.0),
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
            ),
            child: Text(
              'Informasi Tempat Tidur',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: _buildTokenWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingTempatTidurWidget(
                message: snapshot.data.message,
              );
            case Status.ERROR:
              return ErrorTempatTidurWidget(
                message: snapshot.data.message,
                title: 'Terjadi kesalahan',
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Coba lagi'),
                ),
              );
            case Status.COMPLETED:
              if (snapshot.data.data.metadata.code == 500) {
                return ErrorTempatTidurWidget(
                  message: snapshot.data.message,
                  title: 'Terjadi kesalahan',
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Coba lagi'),
                  ),
                );
              }
              return StreamTempatTidurWidget(
                token: snapshot.data.data.response.token,
              );
          }
        }
        return Container();
      },
    );
  }
}

class StreamTempatTidurWidget extends StatefulWidget {
  final String token;

  const StreamTempatTidurWidget({
    Key key,
    this.token,
  }) : super(key: key);

  @override
  _StreamTempatTidurWidgetState createState() =>
      _StreamTempatTidurWidgetState();
}

class _StreamTempatTidurWidgetState extends State<StreamTempatTidurWidget> {
  TempatTidurBloc _tempatTidurBloc = TempatTidurBloc();
  @override
  void initState() {
    super.initState();
    _tempatTidurBloc.tokenSink.add(widget.token);
    _tempatTidurBloc.getTt();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<TempatTidurModel>>(
      stream: _tempatTidurBloc.tempatTidurStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingTempatTidurWidget(
                message: snapshot.data.message,
              );
            case Status.ERROR:
              return ErrorTempatTidurWidget(
                message: snapshot.data.message,
                title: 'Terjadi kesalahan',
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Coba lagi'),
                ),
              );
            case Status.COMPLETED:
              if (!snapshot.data.data.success) {
                return ErrorTempatTidurWidget(
                  message: snapshot.data.message,
                  title: 'Terjadi kesalahan',
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Coba lagi'),
                  ),
                );
              }
              return ResultTempatTidur(
                data: snapshot.data.data.response,
              );
          }
        }
        return Container();
      },
    );
  }
}

class ResultTempatTidur extends StatefulWidget {
  final List<TempatTidur> data;

  const ResultTempatTidur({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _ResultTempatTidurState createState() => _ResultTempatTidurState();
}

class _ResultTempatTidurState extends State<ResultTempatTidur> {
  Map<String, double> chart;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 17,
        childAspectRatio: 3 / 4,
      ),
      itemCount: widget.data.length,
      itemBuilder: (context, i) {
        var tempat = widget.data[i];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(2.0, 2.0),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.hotel,
                    size: 22.0,
                  ),
                  Text(
                    '${tempat.kamar}',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Expanded(
                child: CircularPercentIndicator(
                  radius: 115.0,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 12.0,
                  percent: (double.parse(tempat.terisi) /
                      double.parse(tempat.total)),
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Kosong'),
                      Text(
                        "${tempat.kosong}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.green,
                  progressColor: Colors.red,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Terisi'),
                      Text(
                        '${tempat.terisi}',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total'),
                      Text(
                        '${tempat.total}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 42.0;
}
