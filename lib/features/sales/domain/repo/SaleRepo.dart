import 'package:ribhi/features/sales/domain/entity/sale.dart';

abstract class SaleRepository {
  Future<void> createSale({
    required int productId,
    required int quantity,
  });

  
  Future<List<Sale>> getAll();
  
  Future<List<Sale>> getTodaySales();
}