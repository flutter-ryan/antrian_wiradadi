import 'package:antrian_wiradadi/src/confg/db_helper_identitas.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/confg/transition/slide_bottom_route.dart';
import 'package:antrian_wiradadi/src/pages/components/identitas_pasien.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:flutter/material.dart';

class KonfirmasiIdentitasPasien extends StatefulWidget {
  const KonfirmasiIdentitasPasien({super.key});

  @override
  State<KonfirmasiIdentitasPasien> createState() =>
      _KonfirmasiIdentitasPasienState();
}

class _KonfirmasiIdentitasPasienState extends State<KonfirmasiIdentitasPasien> {
  @override
  Widget build(BuildContext context) {
    return ResponseModalBottom(
      image: 'images/ask.png',
      title: 'Informasi',
      message:
          'Anda belum menyimpan Idenitas pasien terdaftar. Jika ini adalah pertama kalinya Anda menggunakan aplikasi ini silahkan tap tombol pasien baru atau jika Anda adalah pasien terdaftar silahkan tap tombol pasien lama untuk mendaftarkan Identitas Anda',
      button: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                var identitas = ResponseCekIdentitas(
                  jenis: 'pasien-baru',
                  data: null,
                );
                Navigator.pop(context, identitas);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                minimumSize: const Size.fromHeight(45),
              ),
              child: const Text(
                'Pasien Baru',
                style: TextStyle(color: textColorPasienBaru),
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                SlideBottomRoute(
                  page: const IdentitasPasien(form: true),
                ),
              ).then((value) {
                if (value != null) {
                  var data = value as List<IdentitasPasienSql>;
                  var identitas = ResponseCekIdentitas(
                    jenis: 'pasien-lama',
                    data: data,
                  );
                  Navigator.pop(context, identitas);
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size.fromHeight(45),
              ),
              child: const Text('Pasien Lama'),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponseCekIdentitas {
  ResponseCekIdentitas({
    this.jenis,
    this.data,
  });
  String? jenis;
  List<IdentitasPasienSql>? data;
}
