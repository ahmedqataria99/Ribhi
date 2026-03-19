import 'package:ribhi/features/reports/data/datasource/RebortDataStore.dart';
import 'package:ribhi/features/reports/domain/entity/reports.dart';
import 'package:ribhi/features/reports/domain/repo/reportsRepo.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsLocalDataSource local;
  ReportsRepositoryImpl(this.local);

  @override
  Future<DailyReport> getDailyReport(DateTime date) =>
      local.getDailyReport(date);

  @override
  Future<MonthlyReport> getMonthlyReport(DateTime month) =>
      local.getMonthlyReport(month);

  @override
  Future<InventoryReport> getInventoryReport() =>
      local.getInventoryReport();
}