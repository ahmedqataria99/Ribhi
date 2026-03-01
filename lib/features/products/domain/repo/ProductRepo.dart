import 'package:ribhi/features/products/domain/entities/products.dart';

abstract class ProductRepository {
  Future<Product?> getById(int id); 

  Future<List<Product>> getAll();

  Future<void> add(Product product);

  Future<void> update(Product product);

  Future<void> delete(int id);

  Future<List<Product>> search(String keyword);

  Future<List<Product>> filterByCategory(String category);

  Future<List<Product>> getLowStock();
}