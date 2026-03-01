class DashboardSummary {
  final double totalCapital;
  final double inventoryValue;
  final double todaySales;
  final double todayExpenses;
  final double netProfit;
  final int lowStockCount;

  const DashboardSummary({
    required this.totalCapital,
    required this.inventoryValue,
    required this.todaySales,
    required this.todayExpenses,
    required this.netProfit,
    required this.lowStockCount,
  });
}