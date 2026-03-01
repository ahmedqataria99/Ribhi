import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/core/errors/AppExeptions.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/sales/data/datastore/saleDataSource.dart';
import 'package:ribhi/features/sales/data/model/SaleModel.dart';
import 'package:ribhi/features/sales/domain/entity/sale.dart';
import 'package:ribhi/features/sales/domain/repo/SaleRepo.dart';


class SaleRepositoryImpl implements SaleRepository {
  final AppDatabase db;
  final SaleLocalDataSource saleLocal;
  final ProductLocalDataSource productLocal;

  SaleRepositoryImpl({
    required this.db,
    required this.saleLocal,
    required this.productLocal,
  });

  @override
  Future<void> createSale({
    required int productId,
    required int quantity,
  }) async {
    await db.transaction(() async {
      final products = await productLocal.getAll();
      final product =
          products.firstWhere((p) => p.id == productId);

      if (product.quantity < quantity) {
        throw AppException("Not enough stock");
      }

      final newQuantity = product.quantity - quantity;

      final profit =
          (product.sellPrice - product.costPrice) * quantity;

      final amount = product.sellPrice * quantity;

      final updatedProduct = product.copyWith(
        quantity: newQuantity,
        updatedAt: DateTime.now(),
      );

      await productLocal.update(updatedProduct);

      final sale = SaleModel(
        productId: productId,
        quantity: quantity,
        sellPriceSnapshot: product.sellPrice,
        costPriceSnapshot: product.costPrice,
        profit: profit,
        amount: amount,
        createdAt: DateTime.now(),
      );

      await saleLocal.insert(sale);
    });
  }

  @override
  Future<List<Sale>> getAll() async {
    final models = await saleLocal.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Sale>> getTodaySales() async {
    final models = await saleLocal.getToday();
    return models.map((m) => m.toEntity()).toList();
  }
}