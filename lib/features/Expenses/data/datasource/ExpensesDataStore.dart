import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/Expenses/data/models/ExpensesModel.dart';

abstract class ExpenseLocalDataSource {
  Future<void> insert(ExpenseModel model);
  Future<void> delete(int id);
  Future<void> update(ExpenseModel model);
  Future<List<ExpenseModel>> getAll();
  Future<List<ExpenseModel>> getByDate(DateTime date);
}

class ExpenseLocalDataSourceImpl
    implements ExpenseLocalDataSource {

  final AppDatabase db;

  ExpenseLocalDataSourceImpl(this.db);

  @override
  Future<void> insert(ExpenseModel model) async {
    await db.insert('expenses', model.toMap());
  }

  @override
  Future<void> delete(int id) async {
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> update(ExpenseModel model) async {
    await db.update(
      'expenses',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<List<ExpenseModel>> getAll() async {
    final result = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );

    return result.map(ExpenseModel.fromMap).toList();
  }

  @override
  Future<List<ExpenseModel>> getByDate(DateTime date) async {
    final result = await db.query(
      'expenses',
      where: "date(date) = date(?)",
      whereArgs: [date.toIso8601String()],
    );

    return result.map(ExpenseModel.fromMap).toList();
  }
}