import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) async {
    await repository.add(expense);
  }
}
