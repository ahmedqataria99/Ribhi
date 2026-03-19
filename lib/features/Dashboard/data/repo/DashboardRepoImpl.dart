import 'package:ribhi/features/Dashboard/data/datasource/DashboardDataSource.dart';
import 'package:ribhi/features/Dashboard/domain/entity/DashboardStats.dart';
import 'package:ribhi/features/Dashboard/domain/repo/DashboardRepo.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource local;

  DashboardRepositoryImpl(this.local);

  @override
  Future<DashboardStats> getStats() async {
    final model = await local.getStats();
    return model.toEntity();
  }
}
