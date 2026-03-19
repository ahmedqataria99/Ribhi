class DashboardStats {
  final double netProfit;
  final double inventoryValue;
  final double todaySales;
  final double todayExpenses;
  final int lowStockItems;
  final List<DailyProfit> weeklyProfits;

  const DashboardStats({
    required this.netProfit,
    required this.inventoryValue,
    required this.todaySales,
    required this.todayExpenses,
    required this.lowStockItems,
    required this.weeklyProfits,
  });
}

class DailyProfit {
  final String day;
  final double amount;

  const DailyProfit({required this.day, required this.amount});
}
