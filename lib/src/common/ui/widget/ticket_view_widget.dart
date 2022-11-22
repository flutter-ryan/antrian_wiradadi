import 'package:antrian_wiradadi/src/common/source/db_helper.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_firebase_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketViewWidget extends StatefulWidget {
  const TicketViewWidget({Key? key}) : super(key: key);

  @override
  State<TicketViewWidget> createState() => _TicketViewWidgetState();
}

class _TicketViewWidgetState extends State<TicketViewWidget> {
  late PageController _pageController;
  final DbHelper _dbHelper = DbHelper();
  final DateFormat _format = DateFormat('EEEE, dd MMM yyyy');
  List<AntrianSqlliteModel> _tiket = [];
  bool _isTiket = false;
  bool _noTiket = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.95);
    loadDbTicket();
  }

  void loadDbTicket() async {
    await _dbHelper.removeTiketFilter();
    _tiket = await _dbHelper.getTiketAntrian();
    if (_tiket.isNotEmpty) {
      Future.delayed(
        const Duration(milliseconds: 1000),
        () => setState(() {
          _isTiket = true;
          _noTiket = false;
        }),
      );
    } else {
      Future.delayed(
        const Duration(milliseconds: 1000),
        () => setState(() {
          _isTiket = true;
          _noTiket = true;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: !_isTiket
          ? const Center(
              child: StreamResponse(
                image: 'images/loading_transparent.gif',
                message: 'Memuat tiket...',
              ),
            )
          : _noTiket
              ? const Center(
                  child: StreamResponse(
                    image: 'images/server_error_1.png',
                    message: 'Tiket tidak tersedia',
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 12,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _tiket.length,
                        itemBuilder: (context, i) {
                          AntrianSqlliteModel ticket = _tiket[i];

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 28.0, top: 8.0),
                            child: Container(
                              margin: i != 3
                                  ? const EdgeInsets.only(right: 18.0)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6.0,
                                      offset: Offset(1.0, 2.0))
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      padding: const EdgeInsets.all(22.0),
                                      children: [
                                        Container(
                                          height: 62.0,
                                          width: 62.0,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage('images/logo.png'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        const Center(
                                          child: Text(
                                            'Pendaftaran Berhasil',
                                            style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 42.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Tanggal daftar',
                                          text: '${ticket.tanggaldaftar}',
                                        ),
                                        const SizedBox(
                                          height: 12.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Kode booking',
                                          text: ticket.kodebooking,
                                        ),
                                        const SizedBox(
                                          height: 32.0,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: CustomPaint(
                                            painter: DashedLinePainter(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 32.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Nomor antrian',
                                          text: '${ticket.nomorantrean}',
                                        ),
                                        const SizedBox(
                                          height: 22.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'NIK',
                                          text: '${ticket.nik}',
                                        ),
                                        const SizedBox(
                                          height: 22.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Nama pasien',
                                          text: '${ticket.nama}',
                                        ),
                                        const SizedBox(
                                          height: 22.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Poli tujuan',
                                          text: '${ticket.namapoli}',
                                        ),
                                        const SizedBox(
                                          height: 22.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Nama dokter',
                                          text: '${ticket.namadokter}',
                                        ),
                                        const SizedBox(
                                          height: 22.0,
                                        ),
                                        RowTicketWidget(
                                          title: 'Tanggal kunjungan',
                                          text: _format.format(
                                            DateTime.parse(
                                              ticket.tanggalperiksa!,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 32.0,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: CustomPaint(
                                            painter: DashedLinePainter(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 18.0,
                                        ),
                                        Text(
                                          '${ticket.keterangan}',
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamFirebaseTiketWidget(
                                    idPoli: ticket.kodepolirs,
                                    namaPoli: ticket.namapoli,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 6, startX = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RowTicketWidget extends StatelessWidget {
  const RowTicketWidget({
    Key? key,
    this.title,
    this.text,
  }) : super(key: key);

  final String? title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(title!),
        ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              text!,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}

class StreamFirebaseTiketWidget extends StatefulWidget {
  const StreamFirebaseTiketWidget({
    Key? key,
    this.idPoli,
    this.namaPoli,
  }) : super(key: key);

  final String? idPoli;
  final String? namaPoli;

  @override
  State<StreamFirebaseTiketWidget> createState() =>
      _StreamFirebaseTiketWidgetState();
}

class _StreamFirebaseTiketWidgetState extends State<StreamFirebaseTiketWidget> {
  final DateFormat _format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
        color: kPrimaryColor,
        child: StreamBuilder<DocumentSnapshot<FirestoreAntrianPoliModel>>(
          stream: antrianPoliRef.doc('${widget.idPoli}').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_rounded),
                  const SizedBox(
                    width: 18.0,
                  ),
                  Text('${snapshot.error}')
                ],
              );
            }
            if (snapshot.hasData) {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nomor Antrian',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${widget.namaPoli}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  _nomorAntrianWidget(context, snapshot.data!.data()),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 18.0,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  width: 18.0,
                ),
                Text('Memuat...')
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _nomorAntrianWidget(
      BuildContext context, FirestoreAntrianPoliModel? jadwal) {
    if (jadwal == null) {
      return const Text(
        '000',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
      );
    } else if (jadwal.tanggal != _format.format(DateTime.now())) {
      return const Text(
        '000',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
      );
    }
    return Text(
      jadwal.nomor,
      style: const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }
}
