import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.delete(id);
  }
}
