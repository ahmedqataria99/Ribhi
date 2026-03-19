import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';

class GetAllExpensesUseCase {
  final ExpenseRepository repository;

  GetAllExpensesUseCase(this.repository);

  Future<List<Expense>> call() async {
    return await repository.getAll();
  }
}
