import 'package:antrian_wiradadi/src/blocs/pos_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/models/pos_antrian_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/error_resp_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';

import '../blocs/poliklinik_bloc.dart';

class DisplasyAntrianPage extends StatefulWidget {
  const DisplasyAntrianPage({super.key});

  @override
  State<DisplasyAntrianPage> createState() => _DisplasyAntrianPageState();
}

class _DisplasyAntrianPageState extends State<DisplasyAntrianPage> {
  final _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Antrian'),
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
      ),
      body: _streamDisplayAntrian(context),
    );
  }

  Widget _streamDisplayAntrian(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(height: SizeConfig.blockSizeVertical * 35);
            case Status.error:
              return ErrorRespWidget(
                message: snapshot.data!.message,
                reload: () {
                  _tokenBloc.getToken();
                  setState(() {});
                },
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return ErrorRespWidget(
                  message: snapshot.data!.message,
                  reload: () {
                    _tokenBloc.getToken();
                    setState(() {});
                  },
                );
              }
              return PosAntrianDisplay(
                  token: snapshot.data!.data!.response!.token!);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class PosAntrianDisplay extends StatefulWidget {
  const PosAntrianDisplay({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<PosAntrianDisplay> createState() => _PosAntrianDisplayState();
}

class _PosAntrianDisplayState extends State<PosAntrianDisplay> {
  final _posAntrianBloc = PosAntrianBloc();

  @override
  void initState() {
    super.initState();
    _loadPos();
  }

  void _loadPos() {
    _posAntrianBloc.tokenSink.add(widget.token);
    _posAntrianBloc.getPos();
  }

  void _reload() {
    _loadPos();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _posAntrianBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PosAntrianModel>>(
      stream: _posAntrianBloc.posAntrianStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Align(
                alignment: Alignment.center,
                child: LoadingWidget(
                  height: SizeConfig.blockSizeVertical * 40,
                ),
              );
            case Status.error:
              return Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: ErrorRespWidget(
                    message: snapshot.data!.message,
                    reload: _reload,
                  ),
                ),
              );

            case Status.completed:
              if (!snapshot.data!.data!.success) {
                return Align(
                  alignment: Alignment.center,
                  child: ErrorRespWidget(
                    message: 'Data tidak tersedia',
                    reload: _reload,
                  ),
                );
              }
              return _posAntrian(context, snapshot.data!.data!.posAntrian);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _posAntrian(BuildContext context, List<PosAntrian>? data) {
    return DefaultTabController(
      length: data!.length,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: kPrimaryColor),
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  32.0,
                ),
                color: kPrimaryColor,
              ),
              tabs: data
                  .map(
                    (pos) => Tab(
                      text: '${pos.deskripsi}',
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: data
                  .map(
                    (pos) => PoliWidget(
                      data: pos,
                      token: widget.token,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PoliWidget extends StatefulWidget {
  const PoliWidget({
    super.key,
    required this.data,
    required this.token,
  });

  final PosAntrian data;
  final String token;

  @override
  State<PoliWidget> createState() => _PoliWidgetState();
}

class _PoliWidgetState extends State<PoliWidget> {
  final _poliklinikBloc = PoliklinikBloc();

  @override
  void initState() {
    super.initState();
    _loadPoli();
  }

  void _loadPoli() {
    _poliklinikBloc.tokenSink.add(widget.token);
    _poliklinikBloc.posSink.add(widget.data.nomor!);
    _poliklinikBloc.getPoli();
  }

  void _reload() {
    _loadPoli();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _poliklinikBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PoliklinikModel>>(
      stream: _poliklinikBloc.poliStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Align(
                alignment: Alignment.center,
                child: LoadingWidget(
                  height: SizeConfig.blockSizeVertical * 40,
                ),
              );
            case Status.error:
              return Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: ErrorRespWidget(
                    message: snapshot.data!.message,
                    reload: _reload,
                  ),
                ),
              );

            case Status.completed:
              if (!snapshot.data!.data!.success) {
                return Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: ErrorRespWidget(
                      message: 'Data tidak tersedia',
                      reload: _reload,
                    ),
                  ),
                );
              }
              return ListPoli(
                data: snapshot.data!.data!.poliklinik!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPoli extends StatefulWidget {
  const ListPoli({
    super.key,
    required this.data,
  });

  final List<Poliklinik> data;

  @override
  State<ListPoli> createState() => _ListPoliState();
}

class _ListPoliState extends State<ListPoli> {
  List<Poliklinik> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return const Center(
        child: SingleChildScrollView(
          child: ErrorRespWidget(
            message: 'Data tidak ditemukan',
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22.0, 32, 22.0, 32.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 17,
        childAspectRatio: 3 / 4,
      ),
      itemCount: _data.length,
      itemBuilder: (context, i) {
        var poli = _data[i];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 22.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(2.0, 2.0),
              )
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Nomor Antrian',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.end,
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '000',
                    style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text(
                '${poli.deskripsi}',
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
