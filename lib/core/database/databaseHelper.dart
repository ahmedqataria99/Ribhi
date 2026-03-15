import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseSqlite.dart';

class DatabaseHelper implements AppDatabase {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDB('origo_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await DatabaseSqlite.createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            type TEXT NOT NULL,
            created_at TEXT
          )
          ''');
        }
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await _db;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await _db;
    return db.insert(table, values);
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await _db;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await _db;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) async {
    final db = await _db;
    return db.transaction((txn) async {
      return await action();
    });
  }

  @override
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
