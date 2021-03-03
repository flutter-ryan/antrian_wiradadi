import 'package:antrian_wiradadi/src/bloc/poliklinik_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/widget/error_poli_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/skeleton_poli_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/stream_jadwal_widget.dart';
import 'package:antrian_wiradadi/src/model/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class StreamPoliWidget extends StatefulWidget {
  final String token;
  final Function listPoli;
  final AutoScrollController scrollController;
  final Function pilihPoli;
  final bool initial;
  final String idPoli;

  const StreamPoliWidget({
    Key key,
    this.token,
    this.listPoli,
    this.scrollController,
    this.pilihPoli,
    this.idPoli,
    this.initial,
  }) : super(key: key);

  @override
  _StreamPoliWidgetState createState() => _StreamPoliWidgetState();
}

class _StreamPoliWidgetState extends State<StreamPoliWidget> {
  PoliklinikBloc _poliklinikBloc = PoliklinikBloc();

  @override
  void initState() {
    super.initState();
    _poliklinikBloc.tokenSink.add(widget.token);
    _poliklinikBloc.getPoli();
  }

  @override
  void dispose() {
    _poliklinikBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<ApiResponse<PoliklinikModel>>(
        stream: _poliklinikBloc.poliStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return SkeletonPoliWidget();
              case Status.ERROR:
                return ErrorPoliWidget(
                  linkImage: 'assets/images/server_error.png',
                  message: '${snapshot.data.message}',
                );
              case Status.COMPLETED:
                if (!snapshot.data.data.success) {
                  return ErrorPoliWidget(
                    linkImage: 'assets/images/no_data.png',
                    message: 'Data poliklinik tidak tersedia saat ini',
                  );
                }

                return ListPoliWidget(
                  poli: snapshot.data.data.poli,
                  token: widget.token,
                  listPoli: (List<Poliklinik> poli) => widget.listPoli(poli),
                  scrollController: widget.scrollController,
                  pilihPoli: (String idPoli) => widget.pilihPoli(idPoli),
                  idPoli: widget.idPoli,
                  initial: widget.initial,
                );
            }
          }
          return Container();
        },
      ),
    );
  }
}

class ListPoliWidget extends StatefulWidget {
  final List<Poliklinik> poli;
  final String token;
  final Function listPoli;
  final AutoScrollController scrollController;
  final Function pilihPoli;
  final bool initial;
  final String idPoli;

  const ListPoliWidget({
    Key key,
    this.poli,
    this.token,
    this.listPoli,
    this.scrollController,
    this.pilihPoli,
    this.initial,
    this.idPoli,
  }) : super(key: key);
  @override
  _ListPoliWidgetState createState() => _ListPoliWidgetState();
}

class _ListPoliWidgetState extends State<ListPoliWidget> {
  @override
  void initState() {
    super.initState();
    widget.listPoli(widget.poli);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          child: ListView.separated(
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            separatorBuilder: (context, i) {
              return SizedBox(
                width: 18.0,
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: widget.poli.length,
            itemBuilder: (context, i) {
              var poli = widget.poli[i];
              return AutoScrollTag(
                key: ValueKey(int.parse(poli.id)),
                controller: widget.scrollController,
                index: int.parse(poli.id),
                child: Container(
                  width: 140.0,
                  decoration: BoxDecoration(
                    color: widget.initial && i == 0
                        ? Colors.orange
                        : widget.idPoli == poli.id
                            ? Colors.orange
                            : kSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12.0,
                        offset: Offset(2.0, 2.0),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.pilihPoli(poli.id),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 42,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 12.0,
                                      offset: Offset(2.0, 2.0),
                                    )
                                  ],
                                ),
                                child: Icon(Icons.paste),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 8.0, right: 8.0),
                                  child: Text(
                                    '${poli.deskripsi}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.0),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            child: StreamJadwalWidget(
              token: widget.token,
              idPoli: widget.idPoli == null ? widget.poli[0].id : widget.idPoli,
            ),
          ),
        )
      ],
    );
  }
}
