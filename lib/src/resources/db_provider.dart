import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:webnams_app_v3/src/models/image_model.dart';

class DbProvider {
  static final _databaseName = 'app.db';
  static final _databaseVersion = 1;

  static final table = "images";

  static final columnId = "_id";
  static final columnPath = "path";
  static final columnMeterId = "meter_id";

  DbProvider._privateConstructor();
  static final DbProvider instance = DbProvider._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnPath TEXT NOT NULL,
        $columnMeterId INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<ImageModel>> queryAllRows() async {
    Database db = await instance.database;
    var contents = await db.query(table);
    List<ImageModel> rows = [];
    contents.forEach((element) {
      rows.add(ImageModel.fromJson(element));
    });
    return rows;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnMeterId];
    return await db
        .update(table, row, where: '$columnMeterId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnMeterId = ?', whereArgs: [id]);
  }

  Future<ImageModel> queryImage(int meterId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db
        .query(table, where: "$columnMeterId = ?", whereArgs: [meterId]);
    if (results == null || results.isEmpty) {
      return null;
    } else {
      ImageModel result = ImageModel.fromJson(results[0]);
      return result;
    }
  }
}
