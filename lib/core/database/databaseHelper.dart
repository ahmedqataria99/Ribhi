import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseSqlite.dart';

class DatabaseHelper implements AppDatabase {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  String? _dbPath;

  DatabaseHelper._init();

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDB('origo_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    _dbPath = path;

    return await openDatabase(
      path,
      version: 4,
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
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE products ADD COLUMN category_type TEXT',
          );
        }
        if (oldVersion < 4) {
          await db.execute('''
            UPDATE products
            SET min_stock_level = MAX(1, ROUND(quantity * 0.2))
            WHERE min_stock_level <= 1
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

  // 🔥 أهم جزء
  @override
  Future<T> transaction<T>(Future<T> Function(AppDatabase txn) action) async {
    final db = await _db;

    return db.transaction((txn) async {
      final transactionDb = _TransactionDatabase(txn);
      return await action(transactionDb);
    });
  }

  @override
  Future<String> getDatabasePath() async {
    if (_dbPath != null) return _dbPath!;
    await _db;
    return _dbPath!;
  }

  @override
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

class _TransactionDatabase implements AppDatabase {
  final Transaction txn;

  _TransactionDatabase(this.txn);

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    return txn.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    return txn.insert(table, values);
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return txn.update(table, values, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return txn.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<T> transaction<T>(Future<T> Function(AppDatabase txn) action) {
    throw UnsupportedError("Nested transactions not supported");
  }

  @override
  Future<String> getDatabasePath() async {
    throw UnsupportedError('Transaction database does not expose a path');
  }

  @override
  Future<void> close() async {}
}
