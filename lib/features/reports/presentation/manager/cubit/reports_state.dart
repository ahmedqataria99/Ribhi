import 'package:ribhi/features/reports/domain/entity/reports.dart';

abstract class ReportsState {}

class ReportsInitial   extends ReportsState {}
class ReportsLoading   extends ReportsState {}
class ReportsError     extends ReportsState { final String message; ReportsError(this.message); }

class DailyReportLoaded extends ReportsState {
  final DailyReport report;
  DailyReportLoaded(this.report);
}

class MonthlyReportLoaded extends ReportsState {
  final MonthlyReport report;
  MonthlyReportLoaded(this.report);
}

class InventoryReportLoaded extends ReportsState {
  final InventoryReport report;
  InventoryReportLoaded(this.report);
}