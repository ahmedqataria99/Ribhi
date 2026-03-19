import '../../domain/entities/products.dart';

class ProductModel {
  final int? id;
  final String name;
  final double costPrice;
  final double sellPrice;
  final int quantity;
  final String category;
  final String? categoryType;
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
    this.categoryType,
    required this.minStockLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id:            map['id'],
      name:          map['name'],
      costPrice:     (map['cost_price'] as num).toDouble(),
      sellPrice:     (map['sell_price'] as num).toDouble(),
      quantity:      map['quantity'],
      category:      map['category'],
      categoryType:  map['category_type'],
      minStockLevel: map['min_stock_level'],
      createdAt:     DateTime.parse(map['created_at']),
      updatedAt:     DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name':           name,
      'cost_price':     costPrice,
      'sell_price':     sellPrice,
      'quantity':       quantity,
      'category':       category,
      'category_type':  categoryType,
      'min_stock_level': minStockLevel,
      'created_at':     createdAt.toIso8601String(),
      'updated_at':     updatedAt.toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }

  // ✅ copyWith
  ProductModel copyWith({
    int? id,
    String? name,
    double? costPrice,
    double? sellPrice,
    int? quantity,
    String? category,
    String? categoryType,
    int? minStockLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id:            id            ?? this.id,
      name:          name          ?? this.name,
      costPrice:     costPrice     ?? this.costPrice,
      sellPrice:     sellPrice     ?? this.sellPrice,
      quantity:      quantity      ?? this.quantity,
      category:      category      ?? this.category,
      categoryType:  categoryType  ?? this.categoryType,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      createdAt:     createdAt     ?? this.createdAt,
      updatedAt:     updatedAt     ?? this.updatedAt,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id:            product.id,
      name:          product.name,
      costPrice:     product.costPrice,
      sellPrice:     product.sellPrice,
      quantity:      product.quantity,
      category:      product.category,
      categoryType:  product.categoryType,
      minStockLevel: product.minStockLevel,
      createdAt:     product.createdAt,
      updatedAt:     product.updatedAt,
    );
  }

  Product toEntity() {
    return Product(
      id:            id,
      name:          name,
      costPrice:     costPrice,
      sellPrice:     sellPrice,
      quantity:      quantity,
      category:      category,
      categoryType:  categoryType,
      minStockLevel: minStockLevel,
      createdAt:     createdAt,
      updatedAt:     updatedAt,
    );
  }
}