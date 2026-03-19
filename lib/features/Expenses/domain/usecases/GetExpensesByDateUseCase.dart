import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';

class GetExpensesByDateUseCase {
  final ExpenseRepository repository;

  GetExpensesByDateUseCase(this.repository);

  Future<List<Expense>> call(DateTime date) async {
    return await repository.getByDate(date);
  }
}
