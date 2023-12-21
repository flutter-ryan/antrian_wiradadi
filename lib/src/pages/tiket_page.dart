import 'package:antrian_wiradadi/src/confg/db_helper_tiket.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/pages/components/error_resp_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/tiket_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TiketPage extends StatefulWidget {
  const TiketPage({super.key});

  @override
  State<TiketPage> createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  final _tanggalFormat = DateFormat('dd MMMM yyyy', 'id');
  final _dbHelperTiket = DbHelperTiket();
  bool _isLoading = true;
  bool _isError = false;
  List<AntrianSqlliteModel> _tiket = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _loadTiket();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  }

  void _loadTiket() async {
    await _dbHelperTiket.removeTiketFilter();
    var tiket = await _dbHelperTiket.getTiketAntrian();
    await Future.delayed(const Duration(milliseconds: 500));
    if (tiket.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _isError = false;
        _tiket = tiket;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
        _tiket = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey[50],
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: SizeConfig.blockSizeVertical * 35,
                color: kPrimaryColor,
              ),
            ),
            if (_isLoading)
              LoadingWidget(height: SizeConfig.blockSizeVertical * 35)
            else if (_isError)
              Center(
                child: Container(
                  height: SizeConfig.blockSizeVertical * 50,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 12.0,
                        )
                      ]),
                  child: ErrorRespWidget(
                    message: 'Tiket tidak tersedia',
                    reload: () => Navigator.pop(context),
                    buttonText: 'Tutup',
                  ),
                ),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  Flexible(
                    child: _tiketWidget(context),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: _tiket.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey[300]!,
                      activeDotColor: kPrimaryColor,
                    ), // your preferred effect
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _tiketWidget(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, i) {
        var data = _tiket[i];
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: TicketView(
            backgroundPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 35),
            backgroundColor: kPrimaryDarkColor,
            triangleAxis: Axis.vertical,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 25, horizontal: 8),
            borderRadius: 8,
            trianglePos: .0,
            drawTriangle: false,
            drawArc: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18.0, 32.0, 18.0, 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Wrap(
                    runSpacing: 8,
                    children: [
                      Text(
                        'Tiket Antrian Anda',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      Text(
                        'Diharapkan pasien datang 15 menit sebelum jam pelayanan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Nomor Antrian Loket',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                        Text(
                          '${data.nomorantrean}',
                          style: const TextStyle(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryDarkColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Nomor Poliklinik',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                        Text(
                          '${data.nomorantreanpoli}',
                          style: const TextStyle(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryDarkColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataAntrian(
                                  title: 'Nama pasien',
                                  text: '${data.nama}',
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                                DataAntrian(
                                  title: 'Kode booking',
                                  text: '${data.kodebooking}',
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                                DataAntrian(
                                  title: 'Tgl pelayanan',
                                  text: _tanggalFormat.format(
                                      DateTime.parse(data.tanggalperiksa!)),
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataAntrian(
                                  title: 'Poliklinik',
                                  text: '${data.namapoli}',
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                                DataAntrian(
                                  title: 'Jam Poliklinik',
                                  text: '${data.jampraktek}',
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                                DataAntrian(
                                  title: 'Est Pelayanan',
                                  text: '${data.estimasidilayani}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      DataAntrian(
                        title: 'Dokter',
                        text: '${data.namadokter}',
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8)),
                          child: QrImageView(
                            data: '${data.kodebooking}',
                            version: 2,
                            size: 120.0,
                            gapless: false,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: _tiket.length,
    );
  }
}

class DataAntrian extends StatelessWidget {
  const DataAntrian({
    Key? key,
    this.title,
    this.text,
  }) : super(key: key);

  final String? title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          '$text',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
