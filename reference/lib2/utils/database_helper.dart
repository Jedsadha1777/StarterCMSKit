import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = "app_database.db";
  static final _dbVersion = 2;
  static final _tableName = "customers";
  static final _tableName2 = "models";

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, _dbName);

    //await deleteDatabase(path);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS customers (
            id INTEGER PRIMARY KEY,
            code TEXT NOT NULL,
            name TEXT NOT NULL,
            address TEXT
          )
        ''');
          await db.execute('''
          CREATE TABLE IF NOT EXISTS models (
            id INTEGER PRIMARY KEY,
            model TEXT NOT NULL
          )
        ''');
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('PRAGMA encoding = "UTF-8";');
    await db.execute('''
    CREATE TABLE $_tableName (
      id INTEGER PRIMARY KEY,
      code TEXT NOT NULL,
      name TEXT NOT NULL,
      address TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE $_tableName2 (
      id INTEGER PRIMARY KEY,
      model TEXT NOT NULL
    )
    ''');
  }

  Future<void> insertCustomers(List<Map<String, dynamic>> customers) async {
    final db = await database;
    for (var customer in customers) {
      await db.insert(_tableName, customer);
    }
  }

  Future<void> insertModels(List<Map<String, dynamic>> models) async {
    final db = await database;
    for (var model in models) {
      await db.insert(_tableName2, model);
    }
  }

  Future<void> deleteAllCustomers() async {
    final db = await database;
    await db.delete(_tableName); // 清空表数据
  }

  Future<void> deleteAllModels() async {
    final db = await database;
    await db.delete(_tableName2);
  }

  Future<List<Map<String, dynamic>>> searchCustomers(String query) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: "name LIKE ? OR code LIKE ?",
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  Future<List<Map<String, dynamic>>> searchCustomerCodes(String query) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: "code LIKE ?",
      whereArgs: ['%$query%'],
    );
  }

  Future<Map<String, dynamic>?> exactSearchCustomers(String query) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: "code = ?",
      whereArgs: [query],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<List<Map<String, dynamic>>> searchModels(String query) async {
    final db = await database;
    return await db.query(
      _tableName2,
      where: "model LIKE ?",
      whereArgs: ['%$query%'],
    );
  }

  Future<List<Map<String, dynamic>>> getAllModels() async {
    final db = await database;
    return await db.query(_tableName2);
  }
}
