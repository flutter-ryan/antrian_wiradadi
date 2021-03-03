import 'package:antrian_wiradadi/src/bloc/poliklinik_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/error_poli_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/header_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/poli_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/skeleton_poli_widget.dart';
import 'package:antrian_wiradadi/src/model/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TokenBloc _tokenBloc = TokenBloc();
  TutorialCoachMark _tutorialCoachMark;
  List<TargetFocus> _targets = [];

  GlobalKey tutorialKey = GlobalKey();
  GlobalKey searchKey = GlobalKey();
  GlobalKey infoTtKey = GlobalKey();
  GlobalKey tiketKey = GlobalKey();
  GlobalKey poliKey = GlobalKey();

  String id, token;

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
    // _initTargets();
    // showTutorial();
  }

  void showTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      context,
      targets: _targets,
      colorShadow: Colors.blueGrey,
      textSkip: "SKIP",
      paddingFocus: 5,
      opacityShadow: 0.9,
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
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.hotel,
                          color: Colors.blueGrey,
                          key: infoTtKey,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.receipt,
                          color: Colors.blueGrey,
                          key: tiketKey,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Colors.blueGrey,
                          key: tutorialKey,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                HeaderWidget(
                  searchKey: searchKey,
                ),
              ],
            ),
            _buildStreamToken(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamToken(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return SkeletonPoliWidget();
            case Status.ERROR:
              return ErrorPoliWidget(
                message: snapshot.data.message,
              );
            case Status.COMPLETED:
              if (snapshot.data.data.response.token == "0") {
                return ErrorPoliWidget(
                  message: snapshot.data.data.metadata.message,
                );
              }
              return ListPoliWidget(
                token: snapshot.data.data.response.token,
                poliKey: poliKey,
              );
          }
        }
        return Container();
      },
    );
  }

  void _initTargets() {
    _targets.add(
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
                        "Tap pada bagian ini untuk melihat informasi tempat tidur",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    _targets.add(
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap pada bagian ini untuk menampilakn tiket Anda kepada petugas pendaftaran",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    _targets.add(
      TargetFocus(
        identify: "Pencarian",
        keyTarget: searchKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Pencarian",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap pada bagian ini untuk melakukan pencarian poliklinik atau dokter",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    _targets.add(
      TargetFocus(
        identify: "Pilih Poliklinik",
        keyTarget: poliKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Pilih Poliklinik",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap salah satu pada bagian ini untuk memilih poliklinik tujuan rawat",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    _targets.add(
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
                        "Tap pada bagian ini untuk melihat kembali tutorial penggunaan aplikasi antrian online",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/onboarding_1.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class ListPoliWidget extends StatefulWidget {
  final String token;
  final GlobalKey poliKey;

  const ListPoliWidget({
    Key key,
    this.token,
    this.poliKey,
  }) : super(key: key);

  @override
  _ListPoliWidgetState createState() => _ListPoliWidgetState();
}

class _ListPoliWidgetState extends State<ListPoliWidget> {
  PoliklinikBloc _poliklinikBloc = PoliklinikBloc();

  @override
  void initState() {
    super.initState();
    _poliklinikBloc.tokenSink.add(widget.token);
    _poliklinikBloc.getPoli();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PoliklinikModel>>(
      stream: _poliklinikBloc.poliStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return SkeletonPoliWidget();
            case Status.ERROR:
              return ErrorPoliWidget(
                message: snapshot.data.message,
              );
            case Status.COMPLETED:
              return PoliWidget(
                poli: snapshot.data.data.poli,
                token: widget.token,
                poliKey: widget.poliKey,
              );
          }
        }
        return Container();
      },
    );
  }
}
