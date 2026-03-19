import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/reports/domain/entity/reports.dart';

abstract class ReportsLocalDataSource {
  Future<DailyReport>     getDailyReport(DateTime date);
  Future<MonthlyReport>   getMonthlyReport(DateTime month);
  Future<InventoryReport> getInventoryReport();
}

class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  final AppDatabase db;
  ReportsLocalDataSourceImpl(this.db);

  String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ── Daily ──────────────────────────────────────────────────────────
  @override
  Future<DailyReport> getDailyReport(DateTime date) async {
    final prefix = _dateStr(date);

    final allSales    = await db.query('sales');
    final allExpenses = await db.query('expenses');

    final todaySales = allSales
        .where((r) => (r['created_at'] as String? ?? '').startsWith(prefix));
    final todayExpenses = allExpenses
        .where((r) => (r['date'] as String? ?? '').startsWith(prefix));

    final sales    = todaySales.fold<double>(0, (s, r) => s + (r['amount'] as num? ?? 0).toDouble());
    final expenses = todayExpenses.fold<double>(0, (s, r) => s + (r['amount'] as num? ?? 0).toDouble());

    return DailyReport(
      totalSales:           sales,
      totalExpenses:        expenses,
      grossProfit:          sales - expenses,
      numberOfTransactions: todaySales.length,
    );
  }

  // ── Monthly ────────────────────────────────────────────────────────
  @override
  Future<MonthlyReport> getMonthlyReport(DateTime month) async {
    final monthPrefix =
        '${month.year}-${month.month.toString().padLeft(2, '0')}';

    final allSales    = await db.query('sales');
    final allExpenses = await db.query('expenses');

    final monthSales = allSales
        .where((r) => (r['created_at'] as String? ?? '').startsWith(monthPrefix));
    final monthExpenses = allExpenses
        .where((r) => (r['date'] as String? ?? '').startsWith(monthPrefix));

    final totalRevenue = monthSales.fold<double>(
        0, (s, r) => s + (r['amount'] as num? ?? 0).toDouble());
    final totalExpenses = monthExpenses.fold<double>(
        0, (s, r) => s + (r['amount'] as num? ?? 0).toDouble());

    // آخر 7 أيام
    final now    = DateTime.now();
    const labels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final dailyProfits = List.generate(7, (i) {
      final day    = now.subtract(Duration(days: 6 - i));
      final prefix = _dateStr(day);
      final amount = allSales
          .where((r) => (r['created_at'] as String? ?? '').startsWith(prefix))
          .fold<double>(0, (s, r) => s + (r['amount'] as num? ?? 0).toDouble());
      return DailyProfit(day: labels[day.weekday % 7], amount: amount);
    });

    return MonthlyReport(
      totalRevenue:  totalRevenue,
      totalProfit:   totalRevenue - totalExpenses,
      dailyProfits:  dailyProfits,
    );
  }

  // ── Inventory ──────────────────────────────────────────────────────
  @override
  Future<InventoryReport> getInventoryReport() async {
    final products = await db.query('products');

    final totalValue = products.fold<double>(
      0,
      (s, r) =>
          s +
          (r['sell_price'] as num? ?? 0).toDouble() *
              (r['quantity'] as num? ?? 0).toDouble(),
    );

    final lowStock = products
        .where((r) =>
            (r['quantity'] as num? ?? 0) <=
            (r['min_stock_level'] as num? ?? 0))
        .map((r) => LowStockProduct(
              name:      r['name'] as String? ?? '',
              available: (r['quantity'] as num? ?? 0).toInt(),
              minimum:   (r['min_stock_level'] as num? ?? 0).toInt(),
            ))
        .toList();

    return InventoryReport(
      totalInventoryValue: totalValue,
      lowStockProducts:    lowStock,
    );
  }
}