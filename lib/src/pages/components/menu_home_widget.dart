import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/confg/transition/slide_left_route.dart';
import 'package:antrian_wiradadi/src/pages/components/identitas_pasien.dart';
import 'package:antrian_wiradadi/src/pages/new_home_page.dart';
import 'package:antrian_wiradadi/src/pages/tempat_tidur_page.dart';
import 'package:antrian_wiradadi/src/pages/tiket_page.dart';
import 'package:flutter/material.dart';

class MenuHomeWidget extends StatelessWidget {
  const MenuHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuWidget> menu = [
      MenuWidget(
        onTap: () => Navigator.push(
          context,
          SlideLeftRoute(page: const TiketPage()),
        ),
        title: 'Tiket Antrian',
        icon: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kPrimaryDarkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Image.asset(
              'images/tiket.png',
              height: 38,
            ),
          ),
        ),
      ),
      MenuWidget(
        onTap: () => Navigator.push(
            context, SlideLeftRoute(page: const TempatTidurPage())),
        title: 'Tempat Tidur',
        icon: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kPrimaryDarkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Image.asset(
              'images/hospitalbed.png',
              height: 38,
            ),
          ),
        ),
      ),
      MenuWidget(
        onTap: () => Navigator.push(
          context,
          SlideLeftRoute(
            page: const IdentitasPasien(),
          ),
        ),
        title: 'Pasien',
        icon: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kPrimaryDarkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Image.asset(
              'images/medicalrecord.png',
              height: 38,
            ),
          ),
        ),
      ),
    ];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 6 / 7,
      ),
      itemCount: menu.length,
      itemBuilder: (context, i) {
        return menu[i];
      },
    );
  }
}
