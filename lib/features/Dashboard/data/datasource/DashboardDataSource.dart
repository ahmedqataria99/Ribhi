import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/Dashboard/data/models/DashboardModel.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardModel> getStats();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final AppDatabase db;

  DashboardLocalDataSourceImpl(this.db);

  @override
  Future<DashboardModel> getStats() async {
    final allSales    = await db.query('sales');
    final allExpenses = await db.query('expenses');
    final allProducts = await db.query('products');

    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    //  Net profit = total sales amount - total expenses
    final totalSales = allSales.fold<double>(
      0,
      (sum, row) => sum + (row['amount'] as num? ?? 0).toDouble(),
    );
    final totalExpenses = allExpenses.fold<double>(
      0,
      (sum, row) => sum + (row['amount'] as num? ?? 0).toDouble(),
    );

    //  Inventory value = sell_price * quantity
    final inventoryValue = allProducts.fold<double>(
      0,
      (sum, row) =>
          sum +
          (row['sell_price'] as num? ?? 0).toDouble() *
              (row['quantity'] as num? ?? 0).toDouble(),
    );

    //  Today's sales — sales.created_at
    final todaySales = allSales
        .where((row) => (row['created_at'] as String? ?? '').startsWith(todayStr))
        .fold<double>(
          0,
          (sum, row) => sum + (row['amount'] as num? ?? 0).toDouble(),
        );

    //  Today's expenses — expenses.date
    final todayExpenses = allExpenses
        .where((row) => (row['date'] as String? ?? '').startsWith(todayStr))
        .fold<double>(
          0,
          (sum, row) => sum + (row['amount'] as num? ?? 0).toDouble(),
        );

    //  Low stock — min_stock_level
    final lowStockItems = allProducts
        .where((row) =>
            (row['quantity'] as num? ?? 0) <=
            (row['min_stock_level'] as num? ?? 0))
        .length;

    //  Weekly sales — sales.created_at
    final weeklyProfits = _buildWeeklySales(allSales: allSales, now: now);

    return DashboardModel(
      netProfit: totalSales - totalExpenses,
      inventoryValue: inventoryValue,
      todaySales: todaySales,
      todayExpenses: todayExpenses,
      lowStockItems: lowStockItems,
      weeklyProfits: weeklyProfits,
    );
  }

  List<DailyProfitModel> _buildWeeklySales({
    required List<Map<String, dynamic>> allSales,
    required DateTime now,
  }) {
    const dayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final result = <DailyProfitModel>[];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

      final daySales = allSales
          .where((row) => (row['created_at'] as String? ?? '').startsWith(dayStr))
          .fold<double>(
            0,
            (sum, row) => sum + (row['amount'] as num? ?? 0).toDouble(),
          );

      result.add(DailyProfitModel(
        day: dayLabels[day.weekday % 7],
        amount: daySales,
      ));
    }

    return result;
  }
}