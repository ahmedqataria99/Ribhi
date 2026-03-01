import 'package:ribhi/features/products/domain/entities/products.dart';

class ProductModel {
  final int? id;
  final String name;
  final double costPrice;
  final double sellPrice;
  final int quantity;
  final String category;
  final int minStockLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
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

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      costPrice: (map['cost_price'] as num).toDouble(),
      sellPrice: (map['sell_price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      category: map['category'] as String,
      minStockLevel: map['min_stock_level'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cost_price': costPrice,
      'sell_price': sellPrice,
      'quantity': quantity,
      'category': category,
      'min_stock_level': minStockLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      costPrice: costPrice,
      sellPrice: sellPrice,
      quantity: quantity,
      category: category,
      minStockLevel: minStockLevel,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      costPrice: product.costPrice,
      sellPrice: product.sellPrice,
      quantity: product.quantity,
      category: product.category,
      minStockLevel: product.minStockLevel,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  // ✅ copyWith added
  ProductModel copyWith({
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
    return ProductModel(
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