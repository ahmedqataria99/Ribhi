import 'package:ribhi/features/reports/data/datasource/RebortDataStore.dart';
import 'package:ribhi/features/reports/domain/entity/reports.dart';
import 'package:ribhi/features/reports/domain/repo/reportsRepo.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsLocalDataSource local;

  ReportsRepositoryImpl(this.local);

  @override
  Future<ReportSummary> generateReport({
    required DateTime from,
    required DateTime to,
  }) async {

    final salesData =
        await local.getSalesBetween(from, to);

    final expensesData =
        await local.getExpensesBetween(from, to);

    final products =
        await local.getAllProducts();

    final totalSales = salesData.fold<double>(
      0,
      (sum, sale) =>
          sum + (sale['amount'] as num).toDouble(),
    );

    final totalExpenses = expensesData.fold<double>(
      0,
      (sum, expense) =>
          sum + (expense['amount'] as num).toDouble(),
    );

    final inventoryValue = products.fold<double>(
      0,
      (sum, product) {
        final quantity = product['quantity'] as int;
        final costPrice =
            (product['cost_price'] as num).toDouble();
        return sum + (quantity * costPrice);
      },
    );

    final netProfit = totalSales - totalExpenses;

    return ReportSummary(
      from: from,
      to: to,
      totalSales: totalSales,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      inventoryValue: inventoryValue,
    );
  }
}