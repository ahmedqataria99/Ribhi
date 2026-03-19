import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<void> call(Expense expense) async {
    await repository.update(expense);
  }
}
