import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreamFirebaseWidget extends StatefulWidget {
  const StreamFirebaseWidget({
    Key? key,
    required this.idPoli,
  }) : super(key: key);

  final String idPoli;

  @override
  _StreamFirebaseWidgetState createState() => _StreamFirebaseWidgetState();
}

class _StreamFirebaseWidgetState extends State<StreamFirebaseWidget> {
  final DateFormat _format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<FirestoreAntrianPoliModel>>(
      stream: antrianPoliRef.doc(widget.idPoli).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: 120,
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(
                  Icons.no_sim_rounded,
                  size: 18.0,
                  color: kTextColor,
                ),
                Text(
                  'Error',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.data() == null) {
            return const NomorAntrianWidget(
              nomor: '000',
            );
          } else if (snapshot.data!.data()?.tanggal !=
              _format.format(DateTime.now())) {
            return const NomorAntrianWidget(
              nomor: '000',
            );
          }
          return NomorAntrianWidget(
            nomor: snapshot.data!.data()!.nomor,
          );
        }
        return Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Center(
            child: Text(
              'Memuat...',
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        );
      },
    );
  }
}

class NomorAntrianWidget extends StatelessWidget {
  const NomorAntrianWidget({
    Key? key,
    this.nomor,
  }) : super(key: key);

  final String? nomor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Antrian',
            style: TextStyle(fontSize: 12, color: kTextColor),
          ),
          Text(
            nomor!,
            style: const TextStyle(
                fontSize: 18, color: kTextColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class FirestoreAntrianPoliModel {
  FirestoreAntrianPoliModel({
    required this.nomor,
    required this.poli,
    required this.tanggal,
  });

  FirestoreAntrianPoliModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> json)
      : this(
          nomor: json['nomor'] as String,
          poli: json['poli'] as String,
          tanggal: json['tanggal'] as String,
        );

  final String nomor;
  final String poli;
  final String tanggal;

  Map<String, Object> toJson() {
    return {
      'nomor': nomor,
      'poli': poli,
      'tanggal': tanggal,
    };
  }
}

final antrianPoliRef = FirebaseFirestore.instance
    .collection('data')
    .withConverter<FirestoreAntrianPoliModel>(
      fromFirestore: (snapshot, _) =>
          FirestoreAntrianPoliModel.fromJson(snapshot),
      toFirestore: (antrianPoli, _) => antrianPoli.toJson(),
    );
