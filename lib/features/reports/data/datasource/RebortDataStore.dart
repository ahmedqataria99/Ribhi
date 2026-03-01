import 'package:ribhi/core/database/Appdatabase.dart';

abstract class ReportsLocalDataSource {
  Future<List<Map<String, dynamic>>> getSalesBetween(
      DateTime from,
      DateTime to,
  );

  Future<List<Map<String, dynamic>>> getExpensesBetween(
      DateTime from,
      DateTime to,
  );

  Future<List<Map<String, dynamic>>> getAllProducts();
}

class ReportsLocalDataSourceImpl
    implements ReportsLocalDataSource {

  final AppDatabase db;

  ReportsLocalDataSourceImpl(this.db);

  @override
  Future<List<Map<String, dynamic>>> getSalesBetween(
      DateTime from,
      DateTime to,
  ) async {
    return await db.query(
      'sales',
      where: 'created_at BETWEEN ? AND ?',
      whereArgs: [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getExpensesBetween(
      DateTime from,
      DateTime to,
  ) async {
    return await db.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    return await db.query('products');
  }
}