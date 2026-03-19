import 'package:ribhi/features/Expenses/data/datasource/ExpensesDataStore.dart';
import 'package:ribhi/features/Expenses/data/models/ExpensesModel.dart';
import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';


class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource local;

  ExpenseRepositoryImpl(this.local);

  @override
  Future<void> add(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await local.insert(model);
  }

  @override
  Future<void> delete(int id) async {
    await local.delete(id);
  }

  @override
  Future<void> update(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await local.update(model);
  }

  @override
  Future<List<Expense>> getAll() async {
    final models = await local.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Expense>> getByDate(DateTime date) async {
    final models = await local.getByDate(date);
    return models.map((m) => m.toEntity()).toList();
  }
}