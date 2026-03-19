import 'package:ribhi/features/Dashboard/domain/entity/DashboardStats.dart';

class DailyProfitModel {
  final String day;
  final double amount;

  DailyProfitModel({required this.day, required this.amount});

  factory DailyProfitModel.fromMap(Map<String, dynamic> map) {
    return DailyProfitModel(
      day: map['day'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {'day': day, 'amount': amount};

  DailyProfit toEntity() => DailyProfit(day: day, amount: amount);
}

class DashboardModel {
  final double netProfit;
  final double inventoryValue;
  final double todaySales;
  final double todayExpenses;
  final int lowStockItems;
  final List<DailyProfitModel> weeklyProfits;

  DashboardModel({
    required this.netProfit,
    required this.inventoryValue,
    required this.todaySales,
    required this.todayExpenses,
    required this.lowStockItems,
    required this.weeklyProfits,
  });

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      netProfit: (map['netProfit'] as num).toDouble(),
      inventoryValue: (map['inventoryValue'] as num).toDouble(),
      todaySales: (map['todaySales'] as num).toDouble(),
      todayExpenses: (map['todayExpenses'] as num).toDouble(),
      lowStockItems: map['lowStockItems'] as int,
      weeklyProfits: (map['weeklyProfits'] as List)
          .map((e) => DailyProfitModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  DashboardStats toEntity() {
    return DashboardStats(
      netProfit: netProfit,
      inventoryValue: inventoryValue,
      todaySales: todaySales,
      todayExpenses: todayExpenses,
      lowStockItems: lowStockItems,
      weeklyProfits: weeklyProfits.map((e) => e.toEntity()).toList(),
    );
  }
}
