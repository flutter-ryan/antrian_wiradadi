import 'package:antrian_wiradadi/src/bloc/jadwal_hafis_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/pendaftaran_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/poliklinik_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/pendaftaran_page.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/firestore_pos_antrian_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_firebase_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/models/poliklinik_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PoliklinikWidget extends StatefulWidget {
  const PoliklinikWidget({
    Key? key,
    required this.nomorPos,
    this.filter,
    this.deskripsiPos,
  }) : super(key: key);

  final String nomorPos;
  final String? deskripsiPos;
  final String? filter;

  @override
  _PoliklinikWidgetState createState() => _PoliklinikWidgetState();
}

class _PoliklinikWidgetState extends State<PoliklinikWidget> {
  final ScrollController _scrollCon = ScrollController();
  final TokenBloc _tokenBloc = TokenBloc();

  bool _show = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
    _scrollCon.addListener(_onScroll);
  }

  void _onScroll() {
    double offset = _scrollCon.offset;

    ScrollDirection direction = _scrollCon.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (!isScrollingDown && offset > 100) {
        isScrollingDown = true;
        _show = false;
      }
    } else if (direction == ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _show = true;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _containerHeight = 75.0;
    SizeConfig().init(context);
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
                    width: 180,
                    height: 46,
                    child: TextButton(
                      onPressed: () {
                        _tokenBloc.getToken();
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: kTextColor,
                      ),
                      child: const Text('Coba Lagi'),
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
                      width: 180,
                      height: 46,
                      child: TextButton(
                        onPressed: () {
                          _tokenBloc.getToken();
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
              return Stack(
                children: [
                  StreamPoliklinik(
                    nomorPos: widget.nomorPos,
                    token: snapshot.data!.data!.response!.token!,
                    filter: widget.filter,
                    scrollCon: _scrollCon,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      height: _show ? _containerHeight : 0.0,
                      duration: const Duration(milliseconds: 200),
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                          // offset: Offset(-1.0, -1.0),
                        )
                      ]),
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Nomor Antrian Saat Ini',
                        ),
                        subtitle: Text(
                          '${widget.deskripsiPos}',
                        ),
                        trailing: FirestorePosAntrianWidget(
                          nomorPos: widget.nomorPos,
                        ),
                      ),
                    ),
                  )
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class StreamPoliklinik extends StatefulWidget {
  const StreamPoliklinik({
    Key? key,
    required this.nomorPos,
    required this.token,
    this.filter,
    this.scrollCon,
  }) : super(key: key);

  final String token;
  final String nomorPos;
  final String? filter;
  final ScrollController? scrollCon;

  @override
  _StreamPoliklinikState createState() => _StreamPoliklinikState();
}

class _StreamPoliklinikState extends State<StreamPoliklinik> {
  final PoliklinikBloc _poliklinikBloc = PoliklinikBloc();

  @override
  void initState() {
    super.initState();
    _poliklinikBloc.posSink.add(widget.nomorPos);
    _poliklinikBloc.tokenSink.add(widget.token);
    _poliklinikBloc.getPoli();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PoliklinikModel>>(
      stream: _poliklinikBloc.poliStream,
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
                        _poliklinikBloc.getPoli();
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
              if (!snapshot.data!.data!.success) {
                return const Center(
                  child: StreamResponse(
                    image: 'images/server_error_1.png',
                    message: 'Data poliklinik tidak tersedia',
                  ),
                );
              }
              return ListPoliWidget(
                scrollCon: widget.scrollCon,
                polis: snapshot.data!.data!.poliklinik!,
                filter: widget.filter,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPoliWidget extends StatefulWidget {
  const ListPoliWidget({
    Key? key,
    required this.polis,
    this.filter,
    this.scrollCon,
  }) : super(key: key);

  final List<Poliklinik> polis;
  final String? filter;
  final ScrollController? scrollCon;

  @override
  _ListPoliWidgetState createState() => _ListPoliWidgetState();
}

class _ListPoliWidgetState extends State<ListPoliWidget> {
  final TokenBloc _tokenBloc = TokenBloc();
  List<Poliklinik> _buildPoli = [];
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  String? idExpanded = "0";
  final List<GlobalKey<ExpansionTileCardState>> _key = [];
  int? _index;

  @override
  void initState() {
    super.initState();
    _buildPoli = widget.polis;
    listKey();
  }

  @override
  void didUpdateWidget(covariant ListPoliWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      _buildPoli = widget.polis
          .where(
            (element) => element.deskripsi!.toLowerCase().contains(
                  widget.filter!.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void listKey() {
    // ignore: unused_local_variable
    for (var element in _buildPoli) {
      _key.add(GlobalKey<ExpansionTileCardState>());
    }
  }

  void _showJadwalHafis(
      DateTime? date, String? poli, String? namaPoli, String? idPoli) {
    _tokenBloc.getToken();
    Future.delayed(const Duration(milliseconds: 500), () {
      showBarModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
        builder: (context) => Container(
          constraints: BoxConstraints(
            minHeight: SizeConfig.blockSizeVertical * 40,
            maxHeight: SizeConfig.blockSizeVertical * 90,
          ),
          child: _buildTokenStream(
              context, _dateFormat.format(date!), poli, namaPoli, idPoli),
        ),
      ).then((value) {
        if (value != null) {
          JadwalObject jadwal = value as JadwalObject;
          Future.delayed(
            const Duration(milliseconds: 400),
            () => Navigator.push(
              context,
              SlideLeftRoute(
                page: PendaftaranPage(
                  pendaftaranPasienBloc: jadwal.bloc!,
                  jamJadwal: jadwal.dokter!.jam,
                  tanggal: jadwal.tanggal,
                  ruangan: jadwal.ruangan,
                  kdDokter: jadwal.dokter!.kdDokter,
                  namaDokter: jadwal.dokter!.nmDokter,
                ),
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_buildPoli.isEmpty) {
      return Center(
        child: ListView(
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/server_error_1.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Center(
              child: Text(
                'Data poliklinik tidak tersedia',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      controller: widget.scrollCon,
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      itemBuilder: (context, i) {
        Poliklinik data = _buildPoli[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: ExpansionTileCard(
            key: _key[_buildPoli.indexOf(data)],
            baseColor: Colors.white,
            initialElevation: 2.0,
            duration: const Duration(milliseconds: 400),
            expandedTextColor: Colors.black,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            borderRadius: BorderRadius.circular(8.0),
            onExpansionChanged: (bool isOpen) {
              if (isOpen) {
                if (_index != null) {
                  _key[_index!].currentState!.collapse();
                }
                setState(() {
                  _index = _buildPoli.indexOf(data);
                });
              } else {
                setState(() {
                  _index = null;
                });
              }
            },
            title: Row(
              children: [
                StreamFirebaseWidget(idPoli: data.id!),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.deskripsi!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'Mulai: ${data.mulai}',
                        style:
                            const TextStyle(fontSize: 13.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
            children: [
              const Divider(
                thickness: 1.0,
                height: 1.0,
              ),
              _index == _buildPoli.indexOf(data)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 22.0),
                          child: Text(
                            'Tanggal kunjungan',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: DatePicker(
                            DateTime.now(),
                            initialSelectedDate: DateTime.now(),
                            selectionColor: kSecondaryColor,
                            selectedTextColor: Colors.white,
                            daysCount: 13,
                            onDateChange: (date) {
                              if (data.referensi == null ||
                                  data.referensi!.penjamin == null) {
                                Fluttertoast.showToast(
                                  msg: "Jadwal dokter tidak tersedia",
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.black87,
                                );
                                return;
                              }
                              _showJadwalHafis(
                                date,
                                data.referensi!.penjamin!.bpjs!.kdpoli,
                                data.deskripsi,
                                data.id,
                              );
                            },
                            locale: 'id',
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        )
                      ],
                    )
                  : const SizedBox(
                      height: 150,
                    ),
            ],
          ),
        );
      },
      separatorBuilder: (context, i) => const SizedBox(
        height: 18.0,
      ),
      itemCount: _buildPoli.length,
    );
  }

  Widget _buildTokenStream(BuildContext context, String? date, String? poli,
      String? namaPoli, String? idPoli) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 18.0,
                  ),
                  StreamResponse(
                    image: 'images/loading_transparent.gif',
                    message: snapshot.data!.message,
                  ),
                ],
              );
            case Status.error:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 18.0,
                  ),
                  StreamResponse(
                    image: 'images/server_error_1.png',
                    message: snapshot.data!.message,
                  ),
                ],
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 18.0,
                    ),
                    StreamResponse(
                      image: 'images/server_error_1.png',
                      message: snapshot.data!.message,
                    ),
                  ],
                );
              }
              return JadwalDokterHafisWidget(
                token: snapshot.data!.data!.response!.token!,
                date: date!,
                poli: poli!,
                namaPoli: namaPoli!,
                idPoli: idPoli!,
              );
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    );
  }
}

class JadwalDokterHafisWidget extends StatefulWidget {
  const JadwalDokterHafisWidget({
    Key? key,
    required this.token,
    required this.date,
    required this.poli,
    required this.namaPoli,
    required this.idPoli,
  }) : super(key: key);

  final String token;
  final String date;
  final String poli;
  final String namaPoli;
  final String idPoli;

  @override
  DokterHafisWidgetState createState() => DokterHafisWidgetState();
}

class DokterHafisWidgetState extends State<JadwalDokterHafisWidget> {
  final JadwalHafisBloc _hafisBloc = JadwalHafisBloc();
  final DateFormat _formatTanggal = DateFormat('dd MMMM yyyy', 'id');
  final PendaftaranPasienBloc _pendaftaranPasienBloc = PendaftaranPasienBloc();

  @override
  void initState() {
    super.initState();
    _pendaftaranPasienBloc.poliSink.add(widget.idPoli);
    _pendaftaranPasienBloc.poliBpjsSink.add(widget.poli);
    _pendaftaranPasienBloc.tanggalKunjunganSink.add(widget.date);
    _hafisBloc.tokenSink.add(widget.token);
    _hafisBloc.tanggalSink.add(widget.date);
    _hafisBloc.poliSink.add(widget.poli);
    _hafisBloc.getJadwal();
  }

  @override
  void dispose() {
    _hafisBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<JadwalDokterHafisModel>>(
      stream: _hafisBloc.jadwalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamResponse(
                    image: 'images/loading_transparent.gif',
                    message: snapshot.data!.message,
                  ),
                ],
              );
            case Status.error:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamResponse(
                    image: 'images/server_error_1.png',
                    message: snapshot.data!.message,
                  ),
                ],
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    StreamResponse(
                      image: 'images/server_error_1.png',
                      message: 'Jadwal dokter tidak tersedia',
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Jadwal Dokter',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                        subtitle: Text(
                          '${widget.namaPoli} - ${_formatTanggal.format(
                            DateTime.parse(widget.date),
                          )}',
                        ),
                      ),
                    ),
                    ListView.separated(
                        padding: const EdgeInsets.only(bottom: 22.0),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.data!.jadwalDokter!.length,
                        separatorBuilder: (context, i) => Divider(
                              color: Colors.grey[400],
                              height: 0.0,
                            ),
                        itemBuilder: (context, i) {
                          JadwalDokter dokter =
                              snapshot.data!.data!.jadwalDokter![i];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                JadwalObject(
                                  bloc: _pendaftaranPasienBloc,
                                  dokter: dokter,
                                  tanggal: widget.date,
                                  ruangan: widget.namaPoli,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 22.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'images/avatar-user.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dokter.nmDokter!,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text('Jadwal: ${dokter.jam}')
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              );
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
        );
      },
    );
  }
}

class JadwalObject {
  PendaftaranPasienBloc? bloc;
  JadwalDokter? dokter;
  String? tanggal;
  String? ruangan;

  JadwalObject({
    this.bloc,
    this.dokter,
    this.tanggal,
    this.ruangan,
  });
}
