import 'package:ribhi/features/sales/domain/entity/sale.dart';

class SaleModel {
  final int? id;
  final int productId;
  final int quantity;
  final double sellPriceSnapshot;
  final double costPriceSnapshot;
  final double profit;
  final double amount;
  final DateTime createdAt;

  SaleModel({
    this.id,
    required this.productId,
    required this.quantity,
    required this.sellPriceSnapshot,
    required this.costPriceSnapshot,
    required this.profit,
    required this.amount,
    required this.createdAt,
  });

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      sellPriceSnapshot: (map['sell_price_snapshot'] as num).toDouble(),
      costPriceSnapshot: (map['cost_price_snapshot'] as num).toDouble(),
      profit: (map['profit'] as num).toDouble(),
      amount: (map['amount'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'sell_price_snapshot': sellPriceSnapshot,
      'cost_price_snapshot': costPriceSnapshot,
      'profit': profit,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Sale toEntity() {
    return Sale(
      id: id,
      productId: productId,
      quantity: quantity,
      sellPriceSnapshot: sellPriceSnapshot,
      costPriceSnapshot: costPriceSnapshot,
      profit: profit,
      amount: amount,
      createdAt: createdAt,
    );
  }
}