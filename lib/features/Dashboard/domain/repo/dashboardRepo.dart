import 'package:ribhi/features/Dashboard/domain/entity/DashboardStats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getStats();
}
