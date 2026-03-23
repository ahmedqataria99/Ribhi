import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/products/data/model/ProductModel.dart';

abstract class ProductLocalDataSource {
  Future<ProductModel?> getById(int id, [AppDatabase? txn]);

  Future<List<ProductModel>> getAll();

  Future<void> insert(ProductModel model, [AppDatabase? txn]);

  Future<void> update(ProductModel model, [AppDatabase? txn]);

  Future<void> delete(int id, [AppDatabase? txn]);
  Future<List<ProductModel>> search(String keyword);

Future<List<ProductModel>> filterByCategory(String category);

Future<List<ProductModel>> getLowStock();

Future<void> addCategory({required String name, required String type});

Future<List<String>> getCategories();

Future<void> deleteCategory(String category);

Future<void> updateCategory(String oldName, String newName);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase db;

  ProductLocalDataSourceImpl(this.db);

  // 🔹 Get by ID (supports transaction)
  @override
  Future<ProductModel?> getById(int id, [AppDatabase? txn]) async {
    final database = txn ?? db;

    final result = await database.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return ProductModel.fromMap(result.first);
  }

  // 🔹 Get all
  @override
  Future<List<ProductModel>> getAll() async {
    final result = await db.query(
      'products',
      orderBy: 'created_at DESC',
    );

    return result.map(ProductModel.fromMap).toList();
  }

  // 🔹 Insert
  @override
  Future<void> insert(ProductModel model, [AppDatabase? txn]) async {
    final database = txn ?? db;

    await database.insert(
      'products',
      model.toMap(),
    );
  }

  // 🔹 Update
  @override
  Future<void> update(ProductModel model, [AppDatabase? txn]) async {
    final database = txn ?? db;

    if (model.id == null) {
      throw Exception("Product ID is null, cannot update");
    }

    await database.update(
      'products',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // 🔹 Delete
  @override
  Future<void> delete(int id, [AppDatabase? txn]) async {
    final database = txn ?? db;

    await database.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔥👇 دول اللي كانوا ناقصين 👇🔥

  // 🔹 Search
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

  // 🔹 Low stock
  @override
  Future<List<ProductModel>> getLowStock() async {
    final result = await db.query(
      'products',
      where: 'quantity <= min_stock_level',
    );

    return result.map(ProductModel.fromMap).toList();
  }

  // 🔹 Add category
  @override
  Future<void> addCategory({
    required String name,
    required String type,
  }) async {
    await db.insert('categories', {
      'name': name.trim(),
      'type': type.toLowerCase(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // 🔹 Get categories
  @override
  Future<List<String>> getCategories() async {
    final result = await db.query('categories');

    return result.map((e) => (e['name'] ?? '').toString()).toList();
  }

  // 🔹 Delete category
  @override
  Future<void> deleteCategory(String category) async {
    await db.delete(
      'categories',
      where: 'name = ?',
      whereArgs: [category],
    );

    await db.delete(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // 🔹 Update category
  @override
  Future<void> updateCategory(String oldName, String newName) async {
    await db.update(
      'categories',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );
  }
}
