import 'package:ribhi/features/Dashboard/data/datastore/dashboardDatastore.dart';
import 'package:ribhi/features/Dashboard/domain/entity/DashboardSammary.dart';
import 'package:ribhi/features/Dashboard/domain/repo/dashboardRepo.dart';

class DashboardRepositoryImpl
    implements DashboardRepository {

  final DashboardLocalDataSource local;

  DashboardRepositoryImpl(this.local);

  @override
  Future<DashboardSummary> getSummary() async {
    final capital = await local.getTotalCapital();
    final inventory = await local.getInventoryValue();
    final sales = await local.getTodaySales();
    final expenses = await local.getTodayExpenses();
    final lowStock = await local.getLowStockCount();

    final netProfit = sales - expenses;

    return DashboardSummary(
      totalCapital: capital,
      inventoryValue: inventory,
      todaySales: sales,
      todayExpenses: expenses,
      netProfit: netProfit,
      lowStockCount: lowStock,
    );
  }
}