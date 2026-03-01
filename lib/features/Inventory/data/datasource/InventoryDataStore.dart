import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/Inventory/data/model/InventoryModel.dart';

abstract class InventoryAuditLocalDataSource {
  Future<void> insertAdjustment(InventoryAdjustmentModel model);

  Future<List<InventoryAdjustmentModel>> getAll();
}

class InventoryAuditLocalDataSourceImpl
    implements InventoryAuditLocalDataSource {

  final AppDatabase db;

  InventoryAuditLocalDataSourceImpl(this.db);

  @override
  Future<void> insertAdjustment(
      InventoryAdjustmentModel model) async {
    await db.insert(
      'inventory_adjustments',
      model.toMap(),
    );
  }

  @override
  Future<List<InventoryAdjustmentModel>> getAll() async {
    final result = await db.query(
      'inventory_adjustments',
      orderBy: 'date DESC',
    );

    return result
        .map(InventoryAdjustmentModel.fromMap)
        .toList();
  }
}