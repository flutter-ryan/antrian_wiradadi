import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TiketBodyWidget extends StatefulWidget {
  @override
  _TiketBodyWidgetState createState() => _TiketBodyWidgetState();
}

class _TiketBodyWidgetState extends State<TiketBodyWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  String nomor,
      tanggal,
      jam,
      poli,
      nama,
      namaDokter,
      mulaiJadwal,
      selesaiJadwal;
  bool streamTiket = false, errorTiket = false;
  DateFormat _format = DateFormat("EEEE, dd MMMM yyyy", "id");
  @override
  void initState() {
    super.initState();
    loadTiket();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  Future<void> loadTiket() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        nomor = _prefs.get("nomorAntrian");
        tanggal = _prefs.get("tanggalKunjungan");
        jam = _prefs.get("jamKunjungan");
        poli = _prefs.get("poli");
        nama = _prefs.get("namaPasien");
        namaDokter = _prefs.get("namaDokter");
        mulaiJadwal = _prefs.get("mulaiJadwal");
        selesaiJadwal = _prefs.get("selesaiJadwal");
      });
      if (nomor != null) {
        streamTiket = true;
      } else {
        errorTiket = true;
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return streamTiket
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RSU Wiradadi Husada',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.0,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                'Nomor Antrian',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                nomor,
                style: TextStyle(fontSize: 52.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                poli,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                child: Text(
                  namaDokter,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                padding: EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Text(
                      '$nama',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text('${_format.format(DateTime.parse(tanggal))}'),
                    Text(
                      '$mulaiJadwal - $selesaiJadwal',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '*) ',
                          style: TextStyle(color: Colors.red),
                        ),
                        Expanded(
                          child: Text(
                            'Bagi pasien yang sudah mengambil antrian, namun tidak datang diloket sampai 10 nomor antrian selanjutnya, maka pasien harus mengambil ulang antrian',
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.red,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                'Terima kasih atas kunjungan Anda',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.0,
              ),
            ],
          )
        : errorTiket
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 180.0,
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
                      'Saat ini Anda tidak memiliki tiket antrian',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/create_loading.gif'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'Memuat tiket...',
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              );
  }
}
