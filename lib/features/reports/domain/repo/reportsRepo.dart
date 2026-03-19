import 'package:ribhi/features/reports/domain/entity/reports.dart';

abstract class ReportsRepository {
  Future<DailyReport>     getDailyReport(DateTime date);
  Future<MonthlyReport>   getMonthlyReport(DateTime month);
  Future<InventoryReport> getInventoryReport();
}