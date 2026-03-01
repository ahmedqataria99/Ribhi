import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/products/data/model/ProductModel.dart';

abstract class ProductLocalDataSource {
  Future<ProductModel?> getById(int id);

  Future<List<ProductModel>> getAll();

  Future<void> insert(ProductModel model);

  Future<void> update(ProductModel model);

  Future<void> delete(int id);

  Future<List<ProductModel>> search(String keyword);

  Future<List<ProductModel>> filterByCategory(String category);

  Future<List<ProductModel>> getLowStock();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase db;

  ProductLocalDataSourceImpl(this.db);

  // 🔹 Get product by ID
  @override
  Future<ProductModel?> getById(int id) async {
    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return ProductModel.fromMap(result.first);
  }

  // 🔹 Get all products
  @override
  Future<List<ProductModel>> getAll() async {
    final result = await db.query(
      'products',
      orderBy: 'created_at DESC',
    );

    return result.map(ProductModel.fromMap).toList();
  }

  // 🔹 Insert product
  @override
  Future<void> insert(ProductModel model) async {
    await db.insert(
      'products',
      model.toMap(),
    );
  }

  // 🔹 Update product
  @override
  Future<void> update(ProductModel model) async {
    await db.update(
      'products',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // 🔹 Delete product
  @override
  Future<void> delete(int id) async {
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔹 Search by name
  @override
  Future<List<ProductModel>> search(String keyword) async {
    final result = await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
    );

    return result.map(ProductModel.fromMap).toList();
  }

  // 🔹 Filter by category
  @override
  Future<List<ProductModel>> filterByCategory(String category) async {
    final result = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map(ProductModel.fromMap).toList();
  }

  // 🔹 Get low stock products
  @override
  Future<List<ProductModel>> getLowStock() async {
    final result = await db.query(
      'products',
      where: 'quantity <= min_stock_level',
    );

    return result.map(ProductModel.fromMap).toList();
  }
}