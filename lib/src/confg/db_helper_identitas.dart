import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbHelperIdentitas {
  static final DbHelperIdentitas instances = DbHelperIdentitas._();
  static Database? _database;

  DbHelperIdentitas._();

  factory DbHelperIdentitas() {
    return instances;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(directory.path, 'identitas_pasien_antrian');

    var database = await openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE tb_identitas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jenispasien TEXT,
        nik TEXT,
        nohp TEXT,
        norm TEXT NULL DEFAULT NULL,
        nama TEXT,
        tanggal_lahir TEXT,
        nomor_bpjs TEXT NULL DEFAULT NULL,
        status INTEGER DEFAULT 0
        )''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute(
          '''ALTER TABLE tb_identitas ADD COLUMN nomor_bpjs TEXT NULL DEFAULT NULL''');
      await db.execute(
          '''ALTER TABLE tb_identitas ADD COLUMN status INTEGER DEFAULT 0''');
      print("Database was updated!");
    }
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  Future<List<IdentitasPasienSql>> getIdentitas() async {
    var client = await db;
    var res = await client
        .query('tb_identitas', where: 'jenispasien = ?', whereArgs: ["1"]);

    if (res.isNotEmpty) {
      var identitas = res
          .map((identitasMap) => IdentitasPasienSql.fromDb(identitasMap))
          .toList();

      return identitas;
    }

    return [];
  }

  Future<ResponseSelectDb> getRowIdentitas(int? status) async {
    var client = await db;
    var res = await client.query(
      'tb_identitas',
      where: 'status = ?',
      whereArgs: [status],
    );
    if (res.isEmpty) {
      return ResponseSelectDb(success: false, data: null);
    }
    return ResponseSelectDb(
        success: true, data: IdentitasPasienSql.fromDb(res.first));
  }

  Future<List<Map>> cekStatus(int status) async {
    var client = await db;
    var res = await client
        .query('tb_identitas', where: 'status = ?', whereArgs: [status]);
    return res;
  }

  Future<ResponseDb?> createIdentitas(
      IdentitasPasienSql identitasPasienSql) async {
    var client = await db;
    var pasien = await rowCount(identitasPasienSql.nik!);
    var pasienStatus = await rowCounStatus(1);
    if (pasien.isNotEmpty) {
      return ResponseDb(
        success: false,
        message: 'Nik telah terdaftar sebelumnya, Silahkan masukkan nik baru',
      );
    }
    if (pasienStatus.isNotEmpty) {
      await updateStatus(0, null);
    }
    int response = await client.insert(
        'tb_identitas', identitasPasienSql.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    var data = await client
        .query('tb_identitas', where: 'id = ?', whereArgs: [response]);
    List<IdentitasPasienSql> identitas = data
        .map((identitasMap) => IdentitasPasienSql.fromDb(identitasMap))
        .toList();
    return ResponseDb(
      success: true,
      message: 'Sukses menambahkan data baru',
      data: identitas,
    );
  }

  Future<ResponseDb?> updateIdentitas(
      IdentitasPasienUpdateSql identitasPasienUpdateSql, int? id) async {
    var client = await db;
    var pasien = await rowCount(identitasPasienUpdateSql.nik!);
    if (pasien.isNotEmpty && pasien.first.id != id) {
      return ResponseDb(
        success: false,
        message: 'Nik telah terdaftar sebelumnya, Silahkan masukkan nik baru',
      );
    }
    int response = await client.update(
        'tb_identitas', identitasPasienUpdateSql.toMapForDb(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.ignore);
    if (response == 0) {
      return ResponseDb(
          success: false, message: 'Terjadi kesalahan saat memperbaharui data');
    }
    return ResponseDb(success: true, message: 'Sukses memperbaharui data');
  }

  Future<ResponseDb?> updateStatus(int? status, int? id) async {
    var client = await db;
    int response = 0;
    if (id != null) {
      response = await client.update('tb_identitas', {'status': status},
          where: 'id = ?',
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } else {
      response = await client.update('tb_identitas', {'status': status},
          where: 'status = ?',
          whereArgs: [1],
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    if (response == 0) {
      return ResponseDb(
          success: false, message: 'Terjadi kesalahan saat memperbaharui data');
    }
    return ResponseDb(success: true, message: 'Sukses memperbaharui data');
  }

  Future<ResponseDb?> updateNoBpjs(String? nomorBpjs, int? id) async {
    var client = await db;
    int response = await client.update(
        'tb_identitas', {'nomor_bpjs': nomorBpjs},
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.ignore);

    if (response == 0) {
      return ResponseDb(
          success: false, message: 'Terjadi kesalahan saat memperbaharui data');
    }
    return ResponseDb(success: true, message: 'Sukses memperbaharui data');
  }

  Future<List<IdentitasPasienSql>> rowCount(String nik) async {
    var client = await db;
    var data =
        await client.query('tb_identitas', where: 'nik = ?', whereArgs: [nik]);
    return data.map((e) => IdentitasPasienSql.fromDb(e)).toList();
  }

  Future<List<IdentitasPasienSql>> rowCounStatus(int status) async {
    var client = await db;
    var data = await client
        .query('tb_identitas', where: 'status = ?', whereArgs: [status]);
    return data.map((e) => IdentitasPasienSql.fromDb(e)).toList();
  }

  Future<int?> removeIdentitas(int id) async {
    var client = await db;
    return client.delete('tb_identitas', where: 'id = ?', whereArgs: [id]);
  }
}

class IdentitasPasienUpdateSql {
  IdentitasPasienUpdateSql({
    this.jenisPasien,
    this.nama,
    this.nik,
    this.tanggal,
    this.norm,
    this.kontak,
    this.nomorBpjs,
    this.status,
  });

  String? jenisPasien;
  String? nama;
  String? nik;
  String? tanggal;
  String? norm;
  String? kontak;
  String? nomorBpjs;
  int? status;

  Map<String, dynamic> toMapForDb() {
    var map = <String, dynamic>{};
    map["jenispasien"] = jenisPasien;
    map["nama"] = nama;
    map["nik"] = nik;
    map["tanggal_lahir"] = tanggal;
    map["norm"] = norm;
    map["nohp"] = kontak;
    map["nomor_bpjs"] = nomorBpjs;
    map["status"] = status;
    return map;
  }
}

class IdentitasPasienSql {
  IdentitasPasienSql({
    this.id,
    this.jenisPasien,
    this.nama,
    this.nik,
    this.tanggal,
    this.norm,
    this.kontak,
    this.nomorBpjs,
    this.status,
  });

  int? id;
  String? jenisPasien;
  String? nama;
  String? nik;
  String? tanggal;
  String? norm;
  String? kontak;
  String? nomorBpjs;
  int? status;

  IdentitasPasienSql.fromDb(Map<String, dynamic> map)
      : id = map["id"],
        nama = map["nama"],
        jenisPasien = map["jenispasien"],
        nik = map["nik"],
        tanggal = map["tanggal_lahir"],
        norm = map["norm"],
        kontak = map["nohp"],
        nomorBpjs = map["nomor_bpjs"],
        status = map["status"];

  Map<String, dynamic> toMapForDb() {
    var map = <String, dynamic>{};
    map["jenispasien"] = jenisPasien;
    map["nama"] = nama;
    map["nik"] = nik;
    map["tanggal_lahir"] = tanggal;
    map["norm"] = norm;
    map["nohp"] = kontak;
    map["nomor_bpjs"] = nomorBpjs;
    map["status"] = status;
    return map;
  }
}

class ResponseDb {
  ResponseDb({
    this.success = false,
    this.message,
    this.data,
  });

  bool success;
  String? message;
  List<IdentitasPasienSql>? data;
}

class ResponseSelectDb {
  ResponseSelectDb({
    this.success = false,
    this.data,
  });

  bool success;
  IdentitasPasienSql? data;
}
