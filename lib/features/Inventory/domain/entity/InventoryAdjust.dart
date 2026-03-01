class InventoryAdjustment {
  final int? id;
  final int productId;
  final int systemQuantity;
  final int actualQuantity;
  final int difference;
  final DateTime date;

  const InventoryAdjustment({
    this.id,
    required this.productId,
    required this.systemQuantity,
    required this.actualQuantity,
    required this.difference,
    required this.date,
  });
}