import 'package:antrian_wiradadi/src/bloc/pendaftaran_pasien_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/form_pencarian_pasien.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/pasien_baru_form_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/pasien_lama_form_widget.dart';
import 'package:antrian_wiradadi/src/models/cari_pasien_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class PendaftaranPage extends StatefulWidget {
  const PendaftaranPage({
    Key? key,
    this.namaDokter,
    this.jamJadwal,
    this.ruangan,
    this.tanggal,
    this.kdDokter,
    required this.pendaftaranPasienBloc,
  }) : super(key: key);

  final String? namaDokter;
  final String? jamJadwal;
  final String? ruangan;
  final String? tanggal;
  final String? kdDokter;
  final PendaftaranPasienBloc pendaftaranPasienBloc;

  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Pasien? _dataPasien;
  bool _showDialogLama = false;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.pendaftaranPasienBloc.dokterSink.add(widget.kdDokter!);
    widget.pendaftaranPasienBloc.jamPraktekSink.add(widget.jamJadwal!);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabChange);
  }

  void _tabChange() {
    if (_tabController.index == 1 && !_showDialogLama) {
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        animationType: DialogTransitionType.slideFromBottomFade,
        duration: const Duration(milliseconds: 500),
        builder: (context) {
          return const FormPencarianPasien();
        },
      ).then((value) {
        if (value == null) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => _tabController.animateTo(0),
          );
        } else {
          Pasien pasien = value as Pasien;
          setState(() {
            _dataPasien = pasien;
          });
        }
        setState(() {
          _showDialogLama = false;
        });
      });
      setState(() {
        _showDialogLama = true;
      });
    }
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 4.0,
              ),
              SizedBox(
                height: 52,
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Pendaftaran Kunjungan',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1.0,
                                color: Colors.black12,
                                spreadRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            radius: 18.0,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      width: 150,
                      height: 35,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        // give the indicator a decoration (color and border radius)
                        indicator: BoxDecoration(
                          borderRadius: _tabIndex == 0
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(28.0),
                                  bottomLeft: Radius.circular(28.0),
                                )
                              : const BorderRadius.only(
                                  topRight: Radius.circular(28.0),
                                  bottomRight: Radius.circular(28.0),
                                ),
                          color: kSecondaryColor,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: kLightTextColor,
                        tabs: const [
                          Tab(
                            text: 'Baru',
                          ),
                          Tab(
                            text: 'Lama',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          PasienBaruFormWidget(
                            pendaftaranPasienBloc: widget.pendaftaranPasienBloc,
                            namaDokter: widget.namaDokter,
                            jamJadwal: widget.jamJadwal,
                            ruangan: widget.ruangan,
                            tanggal: widget.tanggal,
                          ),
                          PasienLamaFormWidget(
                            pendaftaranPasienBloc: widget.pendaftaranPasienBloc,
                            namaDokter: widget.namaDokter,
                            jamJadwal: widget.jamJadwal,
                            ruangan: widget.ruangan,
                            tanggal: widget.tanggal,
                            pasien: _dataPasien,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
