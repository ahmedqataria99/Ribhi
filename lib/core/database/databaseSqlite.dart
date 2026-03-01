import 'package:sqflite/sqflite.dart';

class DatabaseSqlite {
  static Future<void> createTables(Database db) async {

    await db.execute('''
    CREATE TABLE settings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      store_name TEXT NOT NULL,
      initial_capital REAL,
      currency TEXT,
      is_activated INTEGER DEFAULT 0,
      license_key TEXT,
      created_at TEXT,
      updated_at TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      cost_price REAL NOT NULL DEFAULT 0,
      sell_price REAL NOT NULL DEFAULT 0,
      quantity INTEGER NOT NULL DEFAULT 0,
      category TEXT,
      min_stock_level INTEGER DEFAULT 0,
      created_at TEXT,
      updated_at TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE sales(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL DEFAULT 0,
      sell_price_snapshot REAL NOT NULL DEFAULT 0,
      cost_price_snapshot REAL NOT NULL DEFAULT 0,
      profit REAL NOT NULL DEFAULT 0,
      amount REAL NOT NULL DEFAULT 0,
      created_at TEXT,
      FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE expenses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL DEFAULT 0,
      category TEXT,
      date TEXT,
      notes TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE inventory_adjustments(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      system_quantity INTEGER NOT NULL DEFAULT 0,
      actual_quantity INTEGER NOT NULL DEFAULT 0,
      difference INTEGER NOT NULL DEFAULT 0,
      date TEXT,
      FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
    )
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_products_name ON products(name)');
    await db.execute('CREATE INDEX idx_products_category ON products(category)');
    await db.execute('CREATE INDEX idx_sales_product_id ON sales(product_id)');
    await db.execute('CREATE INDEX idx_sales_created_at ON sales(created_at)');
    await db.execute('CREATE INDEX idx_expenses_date ON expenses(date)');
  }
}