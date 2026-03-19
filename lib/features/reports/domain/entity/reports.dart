// ── Daily Tab ─────────────────────────────
class DailyReport {
  final double totalSales;
  final double totalExpenses;
  final double grossProfit;
  final int numberOfTransactions;

  const DailyReport({
    required this.totalSales,
    required this.totalExpenses,
    required this.grossProfit,
    required this.numberOfTransactions,
  });
}

// ── Monthly Tab ───────────────────────────
class DailyProfit {
  final String day;
  final double amount;
  const DailyProfit({required this.day, required this.amount});
}

class MonthlyReport {
  final double totalRevenue;
  final double totalProfit;
  final List<DailyProfit> dailyProfits;

  const MonthlyReport({
    required this.totalRevenue,
    required this.totalProfit,
    required this.dailyProfits,
  });
}

// ── Inventory Tab ─────────────────────────
class LowStockProduct {
  final String name;
  final int available;
  final int minimum;

  const LowStockProduct({
    required this.name,
    required this.available,
    required this.minimum,
  });

  bool get outOfStock => available == 0;
}

class InventoryReport {
  final double totalInventoryValue;
  final List<LowStockProduct> lowStockProducts;

  const InventoryReport({
    required this.totalInventoryValue,
    required this.lowStockProducts,
  });
}