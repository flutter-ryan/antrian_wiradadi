import 'package:antrian_wiradadi/src/blocs/jadwal_hafis_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/jadwal_dokter_hafis_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StreamJadwalDokter extends StatefulWidget {
  const StreamJadwalDokter({
    super.key,
    this.poliRef,
    this.tanggal,
    this.setJadwal,
    this.reloadDate = false,
    this.penjamin,
  });

  final String? poliRef;
  final String? tanggal;
  final Function(JadwalDokter data)? setJadwal;
  final bool reloadDate;
  final String? penjamin;

  @override
  State<StreamJadwalDokter> createState() => _StreamJadwalDokterState();
}

class _StreamJadwalDokterState extends State<StreamJadwalDokter> {
  final _tokenBloc = TokenBloc();
  JadwalDokter? _data;

  void _pilihJadwal() {
    _tokenBloc.getToken();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.blockSizeVertical * 70,
          ),
          child: _streamJadwalDokter(context),
        );
      },
      duration: const Duration(milliseconds: 600),
    ).then((value) {
      if (value != null) {
        var data = value as JadwalDokter;
        widget.setJadwal!(data);
        setState(() {
          _data = data;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant StreamJadwalDokter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reloadDate != widget.reloadDate) {
      setState(() {
        _data = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadwal Dokter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: _pilihJadwal,
                  child: Text(
                    'Pilih jadwal dokter',
                    style: TextStyle(color: kPrimaryColor.withAlpha(150)),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 12.0,
          ),
          if (_data != null)
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
              leading: Container(
                height: 55,
                width: 55,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Image.asset('images/check_up.png'),
              ),
              title: Text(
                '${_data!.nmDokter}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Jadwal: ${_data!.jam}'),
            )
          else
            const Padding(
              padding: EdgeInsets.all(22.0),
              child: Center(
                child: Text(
                  'Anda belum memilih dokter',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _streamJadwalDokter(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(
                height: SizeConfig.blockSizeVertical * 35,
              );
            case Status.error:
              return ResponseModalBottom(
                title: 'Perhatian',
                message: snapshot.data!.message,
              );

            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return ResponseModalBottom(
                  title: 'Perhatian',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return ListJadwalDokter(
                token: snapshot.data!.data!.response!.token,
                tanggal: widget.tanggal,
                poliRef: widget.poliRef,
                penjamin: widget.penjamin,
                selected: _data?.id,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}

class ListJadwalDokter extends StatefulWidget {
  const ListJadwalDokter({
    super.key,
    this.token,
    this.tanggal,
    this.poliRef,
    this.selected,
    this.penjamin,
  });

  final String? token;
  final String? tanggal;
  final String? poliRef;
  final String? selected;
  final String? penjamin;

  @override
  State<ListJadwalDokter> createState() => _ListJadwalDokterState();
}

class _ListJadwalDokterState extends State<ListJadwalDokter> {
  final _jadwalHafisBloc = JadwalHafisBloc();
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _getJadwalDokter();
  }

  void _getJadwalDokter() {
    if (widget.selected != null) {
      _selectedId = '${widget.selected}';
    }
    _jadwalHafisBloc.tanggalSink.add(widget.tanggal!);
    _jadwalHafisBloc.penjaminSink.add(widget.penjamin);
    _jadwalHafisBloc.tokenSink.add(widget.token!);
    _jadwalHafisBloc.getJadwal();
  }

  void _selected(JadwalDokter jadwal) {
    setState(() {
      _selectedId = jadwal.id;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context, jadwal);
    });
  }

  @override
  void dispose() {
    _jadwalHafisBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (widget.penjamin == null || widget.penjamin == '') {
      return const ResponseModalBottom(
        title: 'Perhatian',
        message: 'Penjamin ruangan tidak ditemukan',
      );
    }
    return StreamBuilder<ApiResponse<JadwalDokterHafisModel>>(
      stream: _jadwalHafisBloc.jadwalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(
                height: SizeConfig.blockSizeVertical * 35,
              );
            case Status.error:
              return ResponseModalBottom(
                title: 'Perhatian',
                message: snapshot.data!.message,
              );

            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return const ResponseModalBottom(
                  title: 'Perhatian',
                  message: 'Data dokter tersedia',
                );
              }
              var dokter = snapshot.data!.data!.jadwalDokter;
              return Container(
                constraints: BoxConstraints(
                  minHeight: SizeConfig.blockSizeVertical * 35,
                  maxHeight: SizeConfig.blockSizeVertical * 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 18.0),
                      child: Text(
                        'Daftar Jadwal Dokter',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    Flexible(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 22.0),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var data = dokter![i];
                          return ListTile(
                            onTap: () => _selected(data),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            selected: _selectedId == data.id ? true : false,
                            selectedColor:
                                _selectedId == data.id ? Colors.black : null,
                            selectedTileColor: _selectedId == data.id
                                ? kPrimaryColor.withAlpha(50)
                                : null,
                            leading: Container(
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withAlpha(100),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Image.asset('images/check_up.png'),
                            ),
                            title: Text(
                              '${data.nmDokter}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('Jadwal: ${data.jam}'),
                          );
                        },
                        separatorBuilder: (context, i) => const Divider(
                          height: 0,
                        ),
                        itemCount: dokter!.length,
                      ),
                    )
                  ],
                ),
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}
