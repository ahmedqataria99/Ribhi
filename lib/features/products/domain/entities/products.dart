class Product {
  final int? id;
  final String name;
  final double costPrice;
  final double sellPrice;
  final int quantity;
  final String category;
  final int minStockLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    this.id,
    required this.name,
    required this.costPrice,
    required this.sellPrice,
    required this.quantity,
    required this.category,
    required this.minStockLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isLowStock => quantity <= minStockLevel;

  double get inventoryValue => quantity * costPrice;

  Product copyWith({
    int? id,
    String? name,
    double? costPrice,
    double? sellPrice,
    int? quantity,
    String? category,
    int? minStockLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}