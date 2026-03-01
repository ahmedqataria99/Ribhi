import 'package:ribhi/features/Inventory/domain/entity/InventoryAdjust.dart';

abstract class InventoryAuditRepository {
  Future<void> adjustStock({
    required int productId,
    required int actualQuantity,
  });

  Future<List<InventoryAdjustment>> getAllAdjustments();
}