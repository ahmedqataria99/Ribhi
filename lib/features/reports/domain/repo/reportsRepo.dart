import 'package:ribhi/features/reports/domain/entity/reports.dart';

abstract class ReportsRepository {
  Future<ReportSummary> generateReport({
    required DateTime from,
    required DateTime to,
  });
}