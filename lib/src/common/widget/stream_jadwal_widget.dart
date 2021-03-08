import 'package:antrian_wiradadi/src/bloc/jadwal_dokter_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/ui/new_daftar_pasien.dart';
import 'package:antrian_wiradadi/src/common/widget/dialog_date_picker.dart';
import 'package:antrian_wiradadi/src/common/widget/dialog_welcome_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/skeleton_jadwal_widget.dart';
import 'package:antrian_wiradadi/src/model/jadwal_dokter_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class StreamJadwalWidget extends StatefulWidget {
  final String idPoli;
  final String token;
  final List<TargetFocus> targets;

  const StreamJadwalWidget({
    Key key,
    this.idPoli,
    this.token,
    this.targets,
  }) : super(key: key);
  @override
  _StreamJadwalWidgetState createState() => _StreamJadwalWidgetState();
}

class _StreamJadwalWidgetState extends State<StreamJadwalWidget> {
  JadwalDokterBloc _jadwalDokterBloc = JadwalDokterBloc();
  GlobalKey jadwalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initTargets();
  }

  @override
  void dispose() {
    _jadwalDokterBloc.dispose();
    super.dispose();
  }

  void loadJadwal() {
    _jadwalDokterBloc.tokenSink.add(widget.token);
    _jadwalDokterBloc.idPoliSink.add(widget.idPoli);
    _jadwalDokterBloc.getJadwal();
  }

  void _pickDate(String idJadwal, String weekday) {
    Future.delayed(Duration(milliseconds: 500), () async {
      final _selected = await showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, child) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: DialogDatePicker(
                weekday: weekday,
              ),
            ),
          );
        },
        pageBuilder: (context, a1, a2) {
          return;
        },
      );
      if (_selected != null) {
        Future.delayed(Duration(milliseconds: 600), () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.0)),
            builder: (context) {
              return SheetJenisPendaftaran(
                pendaftaran: (int idJenis) =>
                    _pendaftaran(idJenis, _selected, widget.idPoli, idJadwal),
              );
            },
          );
        });
      }
    });
  }

  void _pendaftaran(
      int idJenis, String _selected, String idPoli, String idJadwal) {
    Future.delayed(Duration(milliseconds: 600), () {
      if (idJenis == 1) {
        Navigator.push(
            context,
            SlideLeftRoute(
                page: NewDaftarPasien(
              idJenis: idJenis,
              tanggalKunjungan: _selected,
              idPoli: idPoli,
              idJadwal: idJadwal,
            )));
      } else {
        Navigator.push(
            context,
            SlideLeftRoute(
              page: NewDaftarPasien(
                idJenis: idJenis,
                tanggalKunjungan: _selected,
                idPoli: idPoli,
                idJadwal: idJadwal,
              ),
            ));
      }
    });
  }

  void _initTargets() {
    widget.targets.add(
      TargetFocus(
        identify: "Jadwal Dokter",
        keyTarget: jadwalKey,
        shape: ShapeLightFocus.RRect,
        radius: 12.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Jadwal dokter",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tap pada bagian ini untuk memilih jadwal dokter yang Anda inginkan",
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
  Widget build(BuildContext context) {
    loadJadwal();
    return StreamBuilder<ApiResponse<JadwalDokterModel>>(
      stream: _jadwalDokterBloc.jadwalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return SkeletonJadwalWidget();
            case Status.ERROR:
              return Container(
                child: Text('${snapshot.data.message}'),
              );
            case Status.COMPLETED:
              if (!snapshot.data.data.success) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 160.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/no_data.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Text(
                      '${snapshot.data.data.detail}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                );
              }
              return ResultJadwalDokter(
                data: snapshot.data.data.data,
                pickDate: (String idJadwal, String weekday) =>
                    _pickDate(idJadwal, weekday),
                jadwalKey: jadwalKey,
                targets: widget.targets,
              );
          }
        }
        return Container();
      },
    );
  }
}

class ResultJadwalDokter extends StatefulWidget {
  final List<Dokter> data;
  final Function pickDate;
  final GlobalKey jadwalKey;
  final List<TargetFocus> targets;

  const ResultJadwalDokter({
    Key key,
    this.data,
    this.pickDate,
    this.jadwalKey,
    this.targets,
  }) : super(key: key);
  @override
  _ResultJadwalDokterState createState() => _ResultJadwalDokterState();
}

class _ResultJadwalDokterState extends State<ResultJadwalDokter> {
  @override
  void initState() {
    super.initState();
    _showDialog();
  }

  void _showDialog() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String first = _prefs.get('firstTime');
    if (first == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          showGeneralDialog(
              context: context,
              transitionBuilder: (context, a1, a2, child) {
                final curvedValue =
                    Curves.easeInOutBack.transform(a1.value) - 1.0;
                return Transform(
                  transform:
                      Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child: DialogWelcomeWidget(
                      targets: widget.targets,
                    ),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, a1, a2) {
                return;
              });
        });
      });
    }
  }

  void showTutorial() {
    TutorialCoachMark(
      context,
      targets: widget.targets,
      colorShadow: Colors.black,
      textSkip: "Close",
      paddingFocus: 5,
      opacityShadow: 0.8,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2.0, 2.0),
            )
          ]),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.data.length} jadwal dokter ditemukan',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              Icon(
                Icons.rule,
                color: Colors.grey,
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            separatorBuilder: (context, i) {
              return SizedBox(
                height: 18.0,
              );
            },
            itemCount: widget.data.length,
            itemBuilder: (context, i) {
              var jadwal = widget.data[i];
              return Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    offset: Offset(3.0, 3.0),
                  )
                ]),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2.0,
                                  offset: Offset(1.0, 1.0),
                                )
                              ],
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/avatar-nogender.png'))),
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${jadwal.namaDokter}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${jadwal.dokter}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Pilih jadwal dokter',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10.0),
                      physics: ClampingScrollPhysics(),
                      itemCount: jadwal.jadwal.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 2 / 1,
                      ),
                      itemBuilder: (context, i) {
                        var data = jadwal.jadwal[i];
                        var mulai = DateTime.parse('2021-01-01 ${data.mulai}');
                        var selesai =
                            DateTime.parse('2021-01-01 ${data.selesai}');
                        DateFormat _format = DateFormat('HH:mm');
                        return Container(
                          key: i == 0 ? widget.jadwalKey : null,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () =>
                                    widget.pickDate(data.id, data.hari),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${data.deskHari}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${_format.format(mulai)} - ${_format.format(selesai)}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class SheetJenisPendaftaran extends StatelessWidget {
  final Function pendaftaran;

  SheetJenisPendaftaran({
    Key key,
    this.pendaftaran,
  }) : super(key: key);

  final List<JenisPendaftaranModel> jenis = [
    JenisPendaftaranModel(id: 2, deskripsi: 'Pasien Baru'),
    JenisPendaftaranModel(id: 1, deskripsi: 'Pasien Lama'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 22.0),
          child: Text(
            'Jenis Pendaftaran',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, i) {
            return Divider(
              height: 0.0,
            );
          },
          itemCount: jenis.length,
          itemBuilder: (context, i) {
            var data = jenis[i];
            return ListTile(
              onTap: () {
                pendaftaran(data.id);
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
              leading: data.id == 1
                  ? Icon(Icons.person_search_sharp)
                  : Icon(Icons.person_add),
              title: Text('${data.deskripsi}'),
            );
          },
        ),
      ],
    );
  }
}

class JenisPendaftaranModel {
  final int id;
  final String deskripsi;

  JenisPendaftaranModel({this.id, this.deskripsi});
}
