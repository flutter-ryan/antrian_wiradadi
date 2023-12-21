import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:flutter/material.dart';

class JadwalDokterPage extends StatefulWidget {
  const JadwalDokterPage({super.key});

  @override
  State<JadwalDokterPage> createState() => _JadwalDokterPageState();
}

class _JadwalDokterPageState extends State<JadwalDokterPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 35,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
