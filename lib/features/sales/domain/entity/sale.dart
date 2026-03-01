class Sale {
  final int? id;
  final int productId;
  final int quantity;
  final double sellPriceSnapshot;
  final double costPriceSnapshot;
  final double profit;
  final double amount;
  final DateTime createdAt;

  const Sale({
    this.id,
    required this.productId,
    required this.quantity,
    required this.sellPriceSnapshot,
    required this.costPriceSnapshot,
    required this.profit,
    required this.amount,
    required this.createdAt,
  });
}