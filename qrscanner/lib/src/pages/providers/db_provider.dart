import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qrscanner/src/pages/models/scan_model.dart';
export 'package:qrscanner/src/pages/models/scan_model.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future <Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }


  initDB ()async {

    Directory documentsDirectory = await getApplicationSupportDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: ( Database db, int version) async{
        await db.execute(
          'CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')'
        );
      }
    );

  }

//  Create records

  newScanRaw(ScanModel newScan) async{
    final db = await database;

    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES (${newScan.id}, '${newScan.type}', '${newScan.value}' )"
    );
    return res;
  }

  newScan (ScanModel newScan) async{
    final db = await database;

    final res = await db.insert('Scans', newScan.toJson() );

    return res;
  }

//  SELECT - get Information
  Future<ScanModel>getScanId(int id) async{
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id] );

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async{
    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];
    return list;
  }
  
  Future<List<ScanModel>> getAllScansPerType(String type) async{
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");

    List<ScanModel> list = res.isNotEmpty
                              ? res.map((c) => ScanModel.fromJson(c)).toList()
                              : [];
    return list; 
  }

  //Refresh records

  Future updateScan(ScanModel newScan) async{
    final db = await database;

    final res = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);

    return res;
  }

//  Delete records
  Future<int> deleteScan (int id)async{
    final db  = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll ()async{
    final db  = await database;

    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}