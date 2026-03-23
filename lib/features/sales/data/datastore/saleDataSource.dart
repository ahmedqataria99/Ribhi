import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/sales/data/model/SaleModel.dart';

abstract class SaleLocalDataSource {
  SaleLocalDataSource(AppDatabase db);

  Future<void> insert(SaleModel model, [AppDatabase? txn]);
  Future<List<SaleModel>> getAll();
  Future<List<SaleModel>> getToday();
}

class SaleLocalDataSourceImpl implements SaleLocalDataSource {
  final AppDatabase db;

  SaleLocalDataSourceImpl(this.db);

  @override
  Future<void> insert(SaleModel model, [AppDatabase? txn]) async {
    final database = txn ?? db;
    await database.insert('sales', model.toMap());
  }

  @override
  Future<List<SaleModel>> getAll() async {
    final result = await db.query(
      'sales',
      orderBy: 'created_at DESC',
    );
    return result.map(SaleModel.fromMap).toList();
  }

  @override
  Future<List<SaleModel>> getToday() async {
    final result = await db.query(
      'sales',
      where: "date(created_at) = date('now')",
    );
    return result.map(SaleModel.fromMap).toList();
  }
}