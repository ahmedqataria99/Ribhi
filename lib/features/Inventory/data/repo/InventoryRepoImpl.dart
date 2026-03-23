import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/core/errors/AppExeptions.dart';
import 'package:ribhi/features/Inventory/data/datasource/InventoryDataStore.dart';
import 'package:ribhi/features/Inventory/data/model/InventoryModel.dart';
import 'package:ribhi/features/Inventory/domain/entity/InventoryAdjust.dart';
import 'package:ribhi/features/Inventory/domain/repo/InvntoryAdjustRepo.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';

class InventoryAuditRepositoryImpl
    implements InventoryAuditRepository {

  final AppDatabase db;
  final InventoryAuditLocalDataSource local;
  final ProductRepository productRepository;

  InventoryAuditRepositoryImpl({
    required this.db,
    required this.local,
    required this.productRepository,
  });

  @override
  Future<void> adjustStock({
    required int productId,
    required int actualQuantity,
  }) async {

    if (actualQuantity < 0) {
      throw AppException("Quantity cannot be negative");
    }

    await db.transaction((txn) async {
      final product = await productRepository.getById(productId, txn);

      if (product == null) {
        throw AppException("Product not found");
      }

      final systemQuantity = product.quantity;

      final difference = actualQuantity - systemQuantity;

      // تحديث المنتج
      final updatedProduct = product.copyWith(
        quantity: actualQuantity,
        updatedAt: DateTime.now(),
      );

      await productRepository.update(updatedProduct, txn);

      // تسجيل عملية الجرد
      final adjustment = InventoryAdjustmentModel(
        productId: productId,
        systemQuantity: systemQuantity,
        actualQuantity: actualQuantity,
        difference: difference,
        date: DateTime.now(),
      );

      await local.insertAdjustment(adjustment, txn);
    });
  }

  @override
  Future<List<InventoryAdjustment>> getAllAdjustments() async {
    final models = await local.getAll();
    return models.map((m) => m.toEntity()).toList();
  }
}