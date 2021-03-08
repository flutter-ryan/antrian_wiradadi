import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/error_poli_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/skeleton_poli_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/stream_poli_widget.dart';
import 'package:antrian_wiradadi/src/model/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:search_page/search_page.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NewBodyWidget extends StatefulWidget {
  final double height;
  final List<TargetFocus> targets;

  const NewBodyWidget({
    Key key,
    this.height,
    this.targets,
  }) : super(key: key);
  @override
  _NewBodyWidgetState createState() => _NewBodyWidgetState();
}

class _NewBodyWidgetState extends State<NewBodyWidget> {
  AutoScrollController _scrollController = AutoScrollController();
  TokenBloc _tokenBloc = TokenBloc();
  GlobalKey searchKey = GlobalKey();

  List<Poliklinik> _listPoli = [];
  String idPoli;
  bool initial = true;

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
    _initTargets();
  }

  void _pilihPoli(String id) {
    setState(() {
      idPoli = id;
      initial = false;
    });
  }

  void listPoli(List<Poliklinik> poli) {
    _listPoli = poli;
  }

  void _searchPoli() {
    if (_listPoli.length > 0) {
      showSearch(
        context: context,
        delegate: SearchPage<Poliklinik>(
          onQueryUpdate: (s) {},
          items: _listPoli,
          searchLabel: 'Pencarian Poliklinik',
          suggestion: _buildSuggestions(context, _listPoli),
          failure: _buildFailure(context),
          barTheme: ThemeData(
            hintColor: Colors.grey,
            brightness: Brightness.light,
            primaryColor: kPrimaryColor,
            accentColor: kPrimaryColor,
          ),
          filter: (poli) => [
            poli.deskripsi,
          ],
          builder: (poli) => ListTile(
            onTap: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              Future.delayed(Duration(milliseconds: 200), () {
                Navigator.pop(context, poli);
              });
            },
            leading: Icon(Icons.paste),
            title: Text(poli.deskripsi),
          ),
        ),
      ).then((Poliklinik poli) async {
        if (poli != null) {
          _pilihPoli(poli.id);
          await _scrollController.scrollToIndex(
            int.parse(poli.id),
            preferPosition: AutoScrollPosition.middle,
            duration: Duration(seconds: 1),
          );
        }
      });
    }
  }

  void _initTargets() {
    widget.targets.add(
      TargetFocus(
        identify: "Pencarian",
        keyTarget: searchKey,
        shape: ShapeLightFocus.RRect,
        radius: 22,
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
                      "Tap pada bagian ini untuk melakukan pencarian poliklinik",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(top: widget.height - 115),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: _searchPoli,
            child: Container(
              key: searchKey,
              height: 45.0,
              margin: EdgeInsets.symmetric(horizontal: 18.0),
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pencarian poliklinik',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          _buildStreamToken(context),
        ],
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
              return Expanded(
                child: SkeletonPoliWidget(),
              );
            case Status.ERROR:
              return ErrorPoliWidget(
                linkImage: 'assets/images/server_error.png',
                message: '${snapshot.data.message}',
              );
            case Status.COMPLETED:
              if (snapshot.data.data.metadata.code == 500) {
                return ErrorPoliWidget(
                  linkImage: 'assets/images/no_data.png',
                  message: '${snapshot.data.message}',
                );
              }
              return StreamPoliWidget(
                token: snapshot.data.data.response.token,
                listPoli: (List<Poliklinik> poli) => listPoli(poli),
                scrollController: _scrollController,
                pilihPoli: (String idPoli) => _pilihPoli(idPoli),
                idPoli: idPoli,
                initial: initial,
                targets: widget.targets,
              );
          }
        }
        return Container();
      },
    );
  }

  Widget _buildSuggestions(BuildContext context, List<Poliklinik> poliklinik) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'Suggestions',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, int i) {
              return Divider(
                height: 0,
              );
            },
            itemCount: poliklinik.length,
            itemBuilder: (context, int i) {
              var poli = poliklinik[i];
              return ListTile(
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  Future.delayed(Duration(milliseconds: 200), () {
                    Navigator.pop(context, poli);
                  });
                },
                leading: Icon(Icons.history),
                title: Text(poli.deskripsi),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFailure(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/server_error.png'),
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Text(
          'Data poliklinik tidak ditemukan',
          style: TextStyle(
              color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 17.0),
        ),
      ],
    );
  }
}
