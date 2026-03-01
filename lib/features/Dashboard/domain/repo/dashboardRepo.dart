import 'package:ribhi/features/Dashboard/domain/entity/DashboardSammary.dart';


abstract class DashboardRepository {
  Future<DashboardSummary> getSummary();
}