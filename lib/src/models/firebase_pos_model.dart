import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebasePosModel {
  FirebasePosModel({
    required this.nomor,
    required this.pos,
    required this.tanggal,
  });

  final String nomor;
  final String pos;
  final String tanggal;

  FirebasePosModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json)
      : this(
          nomor: json['nomor'] as String,
          pos: json['pos'] as String,
          tanggal: json['tanggal'] as String,
        );

  Map<String, Object> toJson() {
    return {
      'nomor': nomor,
      'pos': pos,
      'tanggal': tanggal,
    };
  }
}

FirebaseApp posApp = Firebase.app('AntrianPosWidget');
final antrianPosRef = FirebaseFirestore.instanceFor(app: posApp)
    .collection('data')
    .withConverter<FirebasePosModel>(
      fromFirestore: (snapshot, _) => FirebasePosModel.fromJson(snapshot),
      toFirestore: (antrianTerakhir, _) => antrianTerakhir.toJson(),
    );
