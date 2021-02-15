import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/slide_left_route.dart';
import 'package:antrian_wiradadi/src/common/ui/daftar_pasien_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selected = 0;

  List<ListPoli> _listPoli = [
    ListPoli(
      'Gigi',
      Icon(
        Icons.assignment_ind,
        color: kSecondaryColor,
        size: 18,
      ),
    ),
    ListPoli(
      'Mata',
      Icon(
        Icons.assignment_ind,
        color: kSecondaryColor,
        size: 18,
      ),
    ),
    ListPoli(
      'Umum',
      Icon(
        Icons.assignment_ind,
        color: kSecondaryColor,
        size: 18,
      ),
    ),
    ListPoli(
      'Jantung',
      Icon(
        Icons.assignment_ind,
        color: kSecondaryColor,
        size: 18,
      ),
    )
  ];

  List<ListDokter> _lisDokter = [
    ListDokter(
      'Dr. Achmad Febriansyah',
      'Poli Gigi & Mulut',
      [
        ListJadwal('Senin', '08:00 - 16:00'),
        ListJadwal('Rabu', '08:00 - 16:00'),
        ListJadwal('Kamis', '08:00 - 16:00'),
      ],
    ),
    ListDokter(
      'Dr. Achmad Zarkasyi',
      'Poli Gigi & Mulut',
      [
        ListJadwal('Selasa', '08:00 - 16:00'),
        ListJadwal('Kamis', '08:00 - 16:00'),
      ],
    ),
  ];

  void _showModalJenisPasien(BuildContext context, String hari) {
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
                          hari: hari,
                          label: 'Pendaftaran Baru',
                        ),
                      ),
                    );
                  },
                  title: Text('Pasien Baru'),
                ),
                ListTile(
                  onTap: () {},
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
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              height: SizeConfig.blockSizeVertical * 38,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22.0),
                  bottomRight: Radius.circular(22.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 28.0,
                            ),
                            Text(
                              'Pendaftaran Online',
                              style: TextStyle(
                                  fontSize: 25.0, color: kSecondaryColor),
                            ),
                            Text(
                              'Pendaftaran Maksimal Pukul 20:00',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13.0),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 40,
                          height: SizeConfig.blockSizeVertical * 18,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/doctor.png'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kSecondaryColor),
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 22.0,
                        ),
                        hintText: 'Cari Dokter',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 32),
                  height: 160,
                  child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 18.0,
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _listPoli.length,
                    itemBuilder: (context, index) {
                      var poli = _listPoli[index];
                      return InkWell(
                        onTap: () {
                          _selected = index;
                          setState(() {});
                        },
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 25,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: _selected == index
                                ? kSecondaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12.0,
                                offset: Offset(2.0, 2.0),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: _selected == index
                                      ? null
                                      : Border.all(color: kSecondaryColor),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: poli.icon,
                                ),
                              ),
                              Text(
                                '${poli.text}',
                                style: TextStyle(
                                    color: _selected == index
                                        ? Colors.white
                                        : kSecondaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_lisDokter.length} dokter gigi ditemukan',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(
                              Icons.segment,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(
                              bottom: 32.0, left: 18.0, right: 18.0),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 18.0,
                            );
                          },
                          itemCount: _lisDokter.length,
                          itemBuilder: (context, index) {
                            var dokter = _lisDokter[index];
                            return Container(
                              padding: EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 62,
                                        height: 62,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/avatar_doc.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 18.0,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${dokter.nama}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              Text(
                                                '${dokter.unit}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 32.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 18.0,
                                  ),
                                  Text(
                                    'Jadwal dokter',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  GridView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3.5 / 1,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.0),
                                    itemCount: dokter.jadwal.length,
                                    itemBuilder: (context, i) {
                                      var jadwal = dokter.jadwal[i];
                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          highlightColor:
                                              kSecondaryColor.withAlpha(80),
                                          onTap: () => _showModalJenisPasien(
                                              context, jadwal.hari),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: kSecondaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${jadwal.hari}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${jadwal.jam}',
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ListPoli {
  final String text;
  final Icon icon;

  ListPoli(
    this.text,
    this.icon,
  );
}

class ListDokter {
  final String nama;
  final String unit;
  final List<ListJadwal> jadwal;

  ListDokter(
    this.nama,
    this.unit,
    this.jadwal,
  );
}

class ListJadwal {
  final String hari;
  final String jam;

  ListJadwal(this.hari, this.jam);
}
