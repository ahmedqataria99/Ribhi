import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final ExpenseRepository repository;

  ExpensesCubit({required this.repository}) : super(ExpensesInitial());

  Future<void> loadExpenses() async {
    emit(ExpensesLoading());
    try {
      final expenses = await repository.getAll();
      emit(ExpensesLoaded(expenses: expenses));
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await repository.add(expense);
      await _refreshExpenses();
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await repository.delete(id);
      await _refreshExpenses();
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await repository.update(expense);
      await _refreshExpenses();
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  void filterByCategory(String? category) {
    final current = state;
    if (current is ExpensesLoaded) {
      if (current.selectedCategory == category) {
        emit(current.copyWith(clearCategory: true));
      } else {
        emit(current.copyWith(selectedCategory: category));
      }
    }
  }

  Future<void> _refreshExpenses() async {
    final current = state;
    final selectedCategory =
        current is ExpensesLoaded ? current.selectedCategory : null;
    final expenses = await repository.getAll();
    emit(ExpensesLoaded(
      expenses: expenses,
      selectedCategory: selectedCategory,
    ));
  }
}
