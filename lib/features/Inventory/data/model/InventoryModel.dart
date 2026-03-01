import 'package:ribhi/features/Inventory/domain/entity/InventoryAdjust.dart';

class InventoryAdjustmentModel {
  final int? id;
  final int productId;
  final int systemQuantity;
  final int actualQuantity;
  final int difference;
  final DateTime date;

  InventoryAdjustmentModel({
    this.id,
    required this.productId,
    required this.systemQuantity,
    required this.actualQuantity,
    required this.difference,
    required this.date,
  });

  factory InventoryAdjustmentModel.fromMap(Map<String, dynamic> map) {
    return InventoryAdjustmentModel(
      id: map['id'],
      productId: map['product_id'],
      systemQuantity: map['system_quantity'],
      actualQuantity: map['actual_quantity'],
      difference: map['difference'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'system_quantity': systemQuantity,
      'actual_quantity': actualQuantity,
      'difference': difference,
      'date': date.toIso8601String(),
    };
  }

  InventoryAdjustment toEntity() {
    return InventoryAdjustment(
      id: id,
      productId: productId,
      systemQuantity: systemQuantity,
      actualQuantity: actualQuantity,
      difference: difference,
      date: date,
    );
  }
}