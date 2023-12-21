import 'package:antrian_wiradadi/src/blocs/poliklinik_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/pos_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/confg/transition/slide_bottom_route.dart';
import 'package:antrian_wiradadi/src/models/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/models/pos_antrian_model.dart';
import 'package:antrian_wiradadi/src/pages/components/error_resp_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/pendaftaran_page.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class PosAntrianWidget extends StatefulWidget {
  const PosAntrianWidget({
    super.key,
    required this.token,
    this.filter,
  });

  final String token;
  final TextEditingController? filter;

  @override
  State<PosAntrianWidget> createState() => _PosAntrianWidgetState();
}

class _PosAntrianWidgetState extends State<PosAntrianWidget> {
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
    if (data?.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            child: Text(
              'Daftar Poliklinik',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PoliWidget(
              data: data!.first,
              token: widget.token,
              filter: widget.filter,
            ),
          )
        ],
      );
    }
    return DefaultTabController(
      length: data!.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12.0,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            child: Text(
              'Daftar Poliklinik',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: data
                  .map(
                    (pos) => PoliWidget(
                      data: pos,
                      token: widget.token,
                      filter: widget.filter,
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
    this.filter,
  });

  final PosAntrian data;
  final String token;
  final TextEditingController? filter;

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
              return const Align(
                alignment: Alignment.center,
                child: LoadingWidget(
                  height: 200,
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
                filter: widget.filter,
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
    this.filter,
    required this.data,
  });

  final TextEditingController? filter;
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
    widget.filter!.addListener(_filterListener);
  }

  void _filterListener() {
    if (widget.filter!.text.isEmpty) {
      _data = widget.data;
    } else {
      _data = widget.data
          .where(
            (poli) => poli.deskripsi!.toLowerCase().contains(
                  widget.filter!.text.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {});
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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
      itemBuilder: (context, i) {
        var poli = _data[i];
        return Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            onTap: () {
              widget.filter?.clear();
              Navigator.push(
                context,
                SlideBottomRoute(
                  page: PendaftaranPage(
                    poli: poli,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset('images/health_white.png'),
              ),
            ),
            title: Text(
              '${poli.deskripsi}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${poli.mulai}'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        );
      },
      separatorBuilder: (context, i) => const SizedBox(
        height: 8.0,
      ),
      itemCount: _data.length,
    );
  }
}
