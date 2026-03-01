import 'package:ribhi/core/database/Appdatabase.dart';

abstract class DashboardLocalDataSource {
  Future<double> getInventoryValue();
  Future<double> getTodaySales();
  Future<double> getTodayExpenses();
  Future<int> getLowStockCount();
  Future<double> getTotalCapital();
}

class DashboardLocalDataSourceImpl
    implements DashboardLocalDataSource {

  final AppDatabase db;

  DashboardLocalDataSourceImpl(this.db);

  @override
  Future<double> getInventoryValue() async {
    final result = await db.query(
      'products',
    );

    if (result.isEmpty) return 0;

    return result.fold<double>(
      0,
      (sum, item) =>
          sum +
          ((item['quantity'] as int) *
              (item['cost_price'] as num).toDouble()),
    );
  }

  @override
  Future<double> getTodaySales() async {
    final result = await db.query(
      'sales',
      where: "date(created_at) = date('now')",
    );

    return result.fold<double>(
      0,
      (sum, item) =>
          sum + (item['amount'] as num).toDouble(),
    );
  }

  @override
  Future<double> getTodayExpenses() async {
    final result = await db.query(
      'expenses',
      where: "date(date) = date('now')",
    );

    return result.fold<double>(
      0,
      (sum, item) =>
          sum + (item['amount'] as num).toDouble(),
    );
  }

  @override
  Future<int> getLowStockCount() async {
    final result = await db.query(
      'products',
      where: 'quantity <= min_stock_level',
    );

    return result.length;
  }

  @override
  Future<double> getTotalCapital() async {
    final result = await db.query('settings');

    if (result.isEmpty) return 0;

    return (result.first['initial_capital'] as num)
        .toDouble();
  }
}