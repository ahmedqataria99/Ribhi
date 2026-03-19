import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';

abstract class ExpenseRepository {
  Future<void> add(Expense expense);

  Future<void> delete(int id);

  Future<void> update(Expense expense);

  Future<List<Expense>> getAll();

  Future<List<Expense>> getByDate(DateTime date);
}