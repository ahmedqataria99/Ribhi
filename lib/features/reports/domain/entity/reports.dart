class ReportSummary {
  final DateTime from;
  final DateTime to;
  final double totalSales;
  final double totalExpenses;
  final double netProfit;
  final double inventoryValue;

  const ReportSummary({
    required this.from,
    required this.to,
    required this.totalSales,
    required this.totalExpenses,
    required this.netProfit,
    required this.inventoryValue,
  });
}