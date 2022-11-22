import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/tempat_tidur_view_widget.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/ticket_view_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({
    Key? key,
    this.tiket = false,
    this.search,
    this.textCon,
  }) : super(key: key);

  final bool tiket;
  final Function(String search)? search;
  final TextEditingController? textCon;

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  int _current = 0;
  bool _clear = false;

  final List<Widget> imageSlider = [
    const SliderImageHeader(
      image: 'images/doctors.png',
      title: 'Temukan Doktermu',
      subtitle:
          'Tersedia informasi tentang nama dan jadwal dokter pada setiap poliklinik',
    ),
    const SliderImageHeader(
      image: 'images/onboarding_3.png',
      title: 'Pilih Jadwal Sendiri',
      subtitle: 'Pilih tanggal sesuai jadwal dokter yang tersedia',
    ),
    const SliderImageHeader(
      image: 'images/queue.png',
      title: 'Tidak Perlu Antri',
      subtitle: 'Anda tidak perlu lagi antri saat pendaftaran diloket',
    ),
  ];

  void _showDialog(String jenis) async {
    showMaterialModalBottomSheet(
      context: context,
      duration: const Duration(milliseconds: 600),
      builder: (context) => SizedBox(
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 20,
              color: kPrimaryColor,
            ),
            jenis == 'ticket'
                ? const TicketViewWidget()
                : const TempatTidurViewWidget(),
            Positioned(
              top: 52.0,
              left: 12.0,
              child: CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Stack(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth,
            child: CarouselSlider(
              items: imageSlider,
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 4 / 3,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: MediaQuery.of(context).padding.top,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: widget.textCon,
                        style: const TextStyle(fontSize: 15.0),
                        textInputAction: TextInputAction.search,
                        onSubmitted: widget.search,
                        onChanged: (value) {
                          setState(() {
                            if (value != '') {
                              _clear = true;
                            } else {
                              _clear = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Pencarian Poliklinik',
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: !_clear
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    widget.search!('');
                                    widget.textCon!.clear();
                                    setState(() {
                                      _clear = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: kLightTextColor,
                    radius: 22.0,
                    child: IconButton(
                      onPressed: () => _showDialog('t.tidur'),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.hotel_outlined,
                        size: 25.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: kLightTextColor,
                    radius: 22.0,
                    child: IconButton(
                      onPressed: () => _showDialog('ticket'),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.receipt_long,
                        size: 25.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageSlider.asMap().entries.map((entry) {
                return Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.white)
                        .withOpacity(
                      _current == entry.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class SliderImageHeader extends StatelessWidget {
  const SliderImageHeader({
    Key? key,
    this.image,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String? image;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 72,
        left: 18.0,
        right: 18.0,
        bottom: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18.0,
                ),
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: kTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  subtitle!,
                  style: TextStyle(color: kLightTextColor, fontSize: 13.0),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 18.0,
          ),
          SizedBox(
            height: 120,
            width: 120,
            child: Image.asset('$image'),
          ),
        ],
      ),
    );
  }
}
