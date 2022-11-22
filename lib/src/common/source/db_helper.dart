import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  final DateFormat _formatDate = DateFormat('yyyy-MM-dd', 'id');

  static final DbHelper instances = DbHelper._();
  static Database? _database;

  DbHelper._();

  factory DbHelper() {
    return instances;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'tiket_antrian');

    var database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE tb_tiket_antrian(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kodebooking TEXT,
        jenispasien TEXT,
        nomorkartu TEXT,
        nik TEXT,
        nohp TEXT,
        kodepoli TEXT,
        namapoli TEXT,
        norm TEXT,
        nama TEXT,
        tanggalperiksa TEXT,
        kodedokter TEXT,
        namadokter TEXT,
        jampraktek TEXT,
        jeniskunjungan INTEGER,
        nomorreferensi TEXT,
        nomorantrean TEXT,
        estimasidilayani INTEGER,
        kodepolirs TEXT,
        keterangan TEXT,
        tanggaldaftar TEXT
        )''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  Future<List<AntrianSqlliteModel>> getTiketAntrian() async {
    var client = await db;
    var res = await client.query('tb_tiket_antrian');

    if (res.isNotEmpty) {
      var tiket =
          res.map((tiketMap) => AntrianSqlliteModel.fromDb(tiketMap)).toList();

      return tiket;
    }

    return [];
  }

  Future<int?> tiketRowCount() async {
    var client = await db;
    return Sqflite.firstIntValue(
        await client.rawQuery('SELECT COUNT(*) FROM tb_tiket_antrian'));
  }

  Future<int?> createTiket(AntrianSqlliteModel antrianSqlliteModel) async {
    var client = await db;
    return client.insert('tb_tiket_antrian', antrianSqlliteModel.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int?> removeTiket(int id) async {
    var client = await db;
    return client.delete('tb_tiket_antrian', where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> removeTiketFilter() async {
    var client = await db;
    var remove = client.delete(
      'tb_tiket_antrian',
      where: 'tanggalperiksa < ?',
      whereArgs: [_formatDate.format(DateTime.now())],
    );

    return remove;
  }
}

class AntrianSqlliteModel {
  int? id;
  String? kodebooking;
  String? jenispasien;
  String? nomorkartu;
  String? nik;
  String? nohp;
  String? kodepoli;
  String? namapoli;
  String? norm;
  String? nama;
  String? tanggalperiksa;
  String? kodedokter;
  String? namadokter;
  String? jampraktek;
  int? jeniskunjungan;
  String? nomorreferensi;
  String? nomorantrean;
  String? angkaantrean;
  int? estimasidilayani;
  String? kodepolirs;
  String? keterangan;
  String? tanggaldaftar;

  AntrianSqlliteModel({
    this.id,
    this.kodebooking,
    this.jenispasien,
    this.nomorkartu,
    this.nik,
    this.nohp,
    this.kodepoli,
    this.namapoli,
    this.norm,
    this.nama,
    this.tanggalperiksa,
    this.kodedokter,
    this.namadokter,
    this.jampraktek,
    this.jeniskunjungan,
    this.nomorreferensi,
    this.nomorantrean,
    this.angkaantrean,
    this.estimasidilayani,
    this.kodepolirs,
    this.keterangan,
    this.tanggaldaftar,
  });

  AntrianSqlliteModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        kodebooking = map['kodebooking'],
        jenispasien = map['jenispasien'],
        nomorkartu = map['nomorkartu'],
        nik = map['nik'],
        nohp = map['nohp'],
        kodepoli = map['kodepoli'],
        namapoli = map['namapoli'],
        norm = map['norm'],
        nama = map['nama'],
        tanggalperiksa = map['tanggalperiksa'],
        kodedokter = map['kodedokter'],
        namadokter = map['namadokter'],
        jampraktek = map['jampraktek'],
        jeniskunjungan = map['jeniskunjungan'],
        nomorreferensi = map['nomorreferensi'],
        nomorantrean = map['nomorantrean'],
        estimasidilayani = map['estimasidilayani'],
        kodepolirs = map['kodepolirs'],
        keterangan = map['keterangan'],
        tanggaldaftar = map['tanggaldaftar'];

  Map<String, dynamic> toMapForDb() {
    var map = <String, dynamic>{};
    map['kodebooking'] = kodebooking;
    map['jenispasien'] = jenispasien;
    map['nomorkartu'] = nomorkartu;
    map['nik'] = nik;
    map['nohp'] = nohp;
    map['kodepoli'] = kodepoli;
    map['namapoli'] = namapoli;
    map['norm'] = norm;
    map['nama'] = nama;
    map['tanggalperiksa'] = tanggalperiksa;
    map['kodedokter'] = kodedokter;
    map['namadokter'] = namadokter;
    map['jampraktek'] = jampraktek;
    map['jeniskunjungan'] = jeniskunjungan;
    map['nomorreferensi'] = nomorreferensi;
    map['nomorantrean'] = nomorantrean;
    map['estimasidilayani'] = estimasidilayani;
    map['keterangan'] = keterangan;
    map['kodepolirs'] = kodepolirs;
    map['tanggaldaftar'] = tanggaldaftar;
    return map;
  }
}