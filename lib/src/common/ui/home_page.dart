import 'dart:io';

import 'package:antrian_wiradadi/src/bloc/pos_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/header_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/poliklinik_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/pos_antrian_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
    this.tiket = false,
  }) : super(key: key);

  final bool tiket;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController textCon = TextEditingController();
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  final TokenBloc _tokenBloc = TokenBloc();
  String? _filter;

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
    checkUpdateVersion();
  }

  void _clearSearch() {
    textCon.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _filter = '';
    });
  }

  void checkUpdateVersion() async {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().catchError(
            (e) {
              //
            },
          );
        }
      }).catchError((e) {
        //
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            HeaderWidget(
              tiket: widget.tiket,
              textCon: textCon,
              search: (String? filter) {
                setState(() {
                  _filter = filter;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: _init,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: StreamResponse(
                          image: 'images/server_error_1.png',
                          message: snapshot.error.toString(),
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: StreamResponse(
                        image: 'images/loading_transparent.gif',
                        message: 'Initialize database',
                      ),
                    );
                  }
                  return _streamTokenBuild(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamTokenBuild(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: StreamResponse(
                  image: 'images/loading_transparent.gif',
                  message: snapshot.data!.message,
                ),
              );
            case Status.error:
              return Center(
                child: StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.message,
                  button: SizedBox(
                    width: 150,
                    height: 45,
                    child: TextButton(
                      onPressed: () => setState(() {
                        _tokenBloc.getToken();
                        setState(() {});
                      }),
                      style: TextButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: kLightTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          )),
                      child: const Text('Coba lagi'),
                    ),
                  ),
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code == 500) {
                return Center(
                  child: StreamResponse(
                    image: 'images/server_error_1.png',
                    message: snapshot.data!.data!.metadata!.message,
                    button: SizedBox(
                      width: 150,
                      height: 45,
                      child: TextButton(
                        onPressed: () => setState(() {
                          _tokenBloc.getToken();
                          setState(() {});
                        }),
                        style: TextButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: kLightTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            )),
                        child: const Text('Coba lagi'),
                      ),
                    ),
                  ),
                );
              }
              return StreamPosAntrian(
                token: snapshot.data!.data!.response!.token!,
                filter: _filter,
                clearSearch: _clearSearch,
              );
          }
        }
        return Container();
      },
    );
  }
}

class StreamPosAntrian extends StatefulWidget {
  const StreamPosAntrian({
    Key? key,
    required this.token,
    this.filter,
    this.clearSearch,
  }) : super(key: key);

  final String token;
  final String? filter;
  final Function()? clearSearch;

  @override
  State<StreamPosAntrian> createState() => _StreamPosAntrianState();
}

class _StreamPosAntrianState extends State<StreamPosAntrian> {
  final PosAntrianBloc _posAntrianBloc = PosAntrianBloc();

  @override
  void initState() {
    super.initState();
    _posAntrianBloc.tokenSink.add(widget.token);
    _posAntrianBloc.getPos();
    _initFirebase();
  }

  void _initFirebase() async {
    try {
      await Firebase.initializeApp(
        name: 'AntrianPosWidget',
        options: Platform.isAndroid
            ? const FirebaseOptions(
                appId: '1:32161464906:android:da07c1cc2905cab17cdcb3',
                apiKey: 'AIzaSyDiZNB5KkGypDSP3OIjL8QqkBjYT9UNRak',
                messagingSenderId: '32161464906',
                projectId: 'antrian-pos-4368d',
              )
            : const FirebaseOptions(
                appId: '1:32161464906:ios:9df08e608768f8747cdcb3',
                apiKey: 'AIzaSyCNInFdL_01PwN4E2EBRj022MyhuV8SrY0',
                messagingSenderId: '32161464906',
                projectId: 'antrian-pos-4368d',
              ),
      );
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') {
        // do nothing
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PosAntrianModel>>(
      stream: _posAntrianBloc.posAntrianStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: StreamResponse(
                  image: 'images/loading_transparent.gif',
                  message: snapshot.data!.message,
                ),
              );
            case Status.error:
              return Center(
                child: StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.message,
                  button: SizedBox(
                    width: 180,
                    height: 46,
                    child: TextButton(
                      onPressed: () {
                        _posAntrianBloc.getPos();
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: kLightTextColor,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ),
                ),
              );
            case Status.completed:
              if (!snapshot.data!.data!.success) {
                return Center(
                  child: StreamResponse(
                    image: 'images/server_error_1.png',
                    message: 'Pos antrian tidak tersedia',
                    button: SizedBox(
                      width: 180,
                      height: 46,
                      child: TextButton(
                        onPressed: () {
                          _posAntrianBloc.getPos();
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: kLightTextColor,
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.data!.data!.posAntrian!.length == 1) {
                return PoliklinikWidget(
                  nomorPos: snapshot.data!.data!.posAntrian![0].nomor!,
                  filter: widget.filter,
                  deskripsiPos: snapshot.data!.data!.posAntrian![0].deskripsi,
                );
              }
              return ListPosAntrianWidget(
                listPosAntrian: snapshot.data!.data!.posAntrian!,
                filter: widget.filter,
                clearSearch: widget.clearSearch,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPosAntrianWidget extends StatefulWidget {
  const ListPosAntrianWidget({
    Key? key,
    required this.listPosAntrian,
    this.filter,
    this.clearSearch,
  }) : super(key: key);

  final List<PosAntrian> listPosAntrian;
  final String? filter;
  final Function()? clearSearch;

  @override
  State<ListPosAntrianWidget> createState() => _ListPosAntrianWidgetState();
}

class _ListPosAntrianWidgetState extends State<ListPosAntrianWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabCon;

  @override
  void initState() {
    super.initState();
    _tabCon = TabController(length: widget.listPosAntrian.length, vsync: this);
    _tabCon.addListener(_onTabChange);
  }

  void _onTabChange() {
    if (_tabCon.indexIsChanging) {
      widget.clearSearch!();
    }
  }

  @override
  void dispose() {
    _tabCon.dispose();
    _tabCon.removeListener(_onTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12.0,
        ),
        SizedBox(
          width: SizeConfig.screenWidth,
          child: TabBar(
            controller: _tabCon,
            isScrollable: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            labelPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 18.0),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: kPrimaryColor,
            ),
            labelColor: kTextColor,
            unselectedLabelColor: kLightTextColor,
            tabs: widget.listPosAntrian.map((pos) {
              return Tab(
                text: pos.deskripsi,
                height: 45.0,
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCon,
            children: widget.listPosAntrian
                .map(
                  (pos) => PoliklinikWidget(
                    nomorPos: pos.nomor!,
                    filter: widget.filter,
                    deskripsiPos: pos.deskripsi,
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
