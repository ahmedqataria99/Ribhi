import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/model/ProductModel.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource local;

  ProductRepositoryImpl(this.local);

  @override
  Future<Product?> getById(int id) async {
    final model = await local.getById(id);
    return model?.toEntity();
  }

  @override
  Future<List<Product>> getAll() async {
    final models = await local.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> add(Product product) async {
    final model = ProductModel.fromEntity(product);
    await local.insert(model);
  }

  @override
  Future<void> update(Product product) async {
    final model = ProductModel.fromEntity(product);
    await local.update(model);
  }

  @override
  Future<void> delete(int id) async {
    await local.delete(id);
  }

  @override
  Future<List<Product>> search(String keyword) async {
    final models = await local.search(keyword);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Product>> filterByCategory(String category) async {
    final models = await local.filterByCategory(category);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Product>> getLowStock() async {
    final models = await local.getLowStock();
    return models.map((m) => m.toEntity()).toList();
  }
}
