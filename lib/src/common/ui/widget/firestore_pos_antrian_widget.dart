import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/models/firebase_pos_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirestorePosAntrianWidget extends StatefulWidget {
  const FirestorePosAntrianWidget({
    Key? key,
    required this.nomorPos,
  }) : super(key: key);

  final String nomorPos;

  @override
  State<FirestorePosAntrianWidget> createState() =>
      _FirestorePosAntrianWidgetState();
}

class _FirestorePosAntrianWidgetState extends State<FirestorePosAntrianWidget> {
  final DateFormat _format = DateFormat('yyyy-MM-dd');
  final DateTime _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<FirebasePosModel>>(
      stream: antrianPosRef.doc(widget.nomorPos).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(
            Icons.warning_amber_rounded,
            size: 32.0,
            color: Colors.red,
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.data() == null) {
            return const Text(
              '000',
              style: TextStyle(fontSize: 22.0),
            );
          } else if (snapshot.data!.data()?.tanggal != _format.format(_now)) {
            return const Text(
              '000',
              style: TextStyle(fontSize: 22.0),
            );
          }

          return Text(
            '${snapshot.data!.data()?.nomor}',
            style: const TextStyle(fontSize: 22.0),
          );
        }
        return const SizedBox(
          width: 18.0,
          height: 18.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
            strokeWidth: 1,
          ),
        );
      },
    );
  }
}
