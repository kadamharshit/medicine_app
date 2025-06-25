import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medicine.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        when_to_take TEXT,
        why_to_take TEXT,
        image_path TEXT
      )
    ''');
    }
  Future <int> insertMedicine(Map<String, dynamic> data )async {
    final db = await database;
    return await db.insert('medicines', data);
  }
  Future<List<Map<String, dynamic>>> getAllMedicines() async {
    final db = await database;
    return await db.query('medicines');
  }

 Future<Map<String, dynamic>?> getMedicineById(int id) async {
  final db = await database;
  final result = await db.query('medicines', where: 'id = ?', whereArgs: [id]);
  return result.isNotEmpty ? result.first : null;
}

}