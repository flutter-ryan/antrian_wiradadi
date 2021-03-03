import 'package:antrian_wiradadi/src/bloc/jadwal_dokter_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/ui/daftar_pasien_page.dart';
import 'package:antrian_wiradadi/src/common/widget/error_jadwal_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/skeleton_jadwal_widget.dart';
import 'package:antrian_wiradadi/src/model/jadwal_dokter_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class JadwalWidget extends StatefulWidget {
  final String token;
  final String idPoli;
  final ScrollController controller;
  final String namaPoli;

  const JadwalWidget({
    Key key,
    this.token,
    this.idPoli,
    this.controller,
    this.namaPoli,
  }) : super(key: key);

  @override
  _JadwalWidgetState createState() => _JadwalWidgetState();
}

class _JadwalWidgetState extends State<JadwalWidget> {
  JadwalDokterBloc _jadwalDokterBloc = JadwalDokterBloc();

  @override
  void initState() {
    super.initState();
    getJadwal();
  }

  void getJadwal() {
    _jadwalDokterBloc.tokenSink.add(widget.token);
    _jadwalDokterBloc.idPoliSink.add(widget.idPoli);
    _jadwalDokterBloc.getJadwal();
  }

  void _showModalJenisPasien(BuildContext context, List<Jadwal> jadwal,
      String idDokter, String namaDokter) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 52.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400], width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 22.0,
                ),
                Text(
                  'Jenis pendaftaran',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12.0,
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        page: DaftarPasienPage(
                          jadwal: jadwal,
                          label: 'Pasien Baru',
                          idDokter: idDokter,
                          idPoli: widget.idPoli,
                          namaPoli: widget.namaPoli,
                          namaDokter: namaDokter,
                          jenisPendaftaran: "2",
                        ),
                      ),
                    );
                  },
                  title: Text('Pasien Baru'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        page: DaftarPasienPage(
                          jadwal: jadwal,
                          label: 'Pasien Lama',
                          idDokter: idDokter,
                          idPoli: widget.idPoli,
                          namaPoli: widget.namaPoli,
                          namaDokter: namaDokter,
                          jenisPendaftaran: "1",
                        ),
                      ),
                    );
                  },
                  title: Text('Pasien Lama'),
                ),
                SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<JadwalDokterModel>>(
      stream: _jadwalDokterBloc.jadwalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return SkeletonJadwalWidget();
            case Status.ERROR:
              return ErrorJadwalWidget(
                message: snapshot.data.message,
              );
            case Status.COMPLETED:
              // return SkeletonJadwalWidget();
              if (!snapshot.data.data.success) {
                return ErrorJadwalWidget(
                  message: snapshot.data.data.detail,
                );
              }
              return Container(
                margin: EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.0),
                    topRight: Radius.circular(22.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(2.0, -1.0),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${snapshot.data.data.data.length} dokter ditemukan',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          Icon(
                            Icons.segment,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: widget.controller,
                        padding: EdgeInsets.only(
                            bottom: 32.0, left: 18.0, right: 18.0),
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: snapshot.data.data.data.length,
                        itemBuilder: (context, index) {
                          var dokter = snapshot.data.data.data[index];
                          return ListTile(
                            onTap: () => _showModalJenisPasien(
                              context,
                              dokter.jadwal,
                              dokter.dokter,
                              dokter.namaDokter,
                            ),
                            leading: Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/avatar_doc.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text('${dokter.namaDokter}'),
                            subtitle: Text('${dokter.dokter}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        }
        return Container();
      },
    );
  }
}
