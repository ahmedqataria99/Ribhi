import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';

abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;
  final String? selectedCategory;

  ExpensesLoaded({
    required this.expenses,
    this.selectedCategory,
  });

  double get totalAmount =>
      expenses.fold(0, (sum, e) => sum + e.amount);

  List<Expense> get filteredExpenses {
    if (selectedCategory == null) return expenses;
    return expenses
        .where((e) => e.category == selectedCategory)
        .toList();
  }

  Map<String, double> get distributionByCategory {
    final Map<String, double> map = {};
    for (final expense in expenses) {
      map[expense.category] =
          (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }

  ExpensesLoaded copyWith({
    List<Expense>? expenses,
    String? selectedCategory,
    bool clearCategory = false,
  }) {
    return ExpensesLoaded(
      expenses: expenses ?? this.expenses,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
    );
  }
}

class ExpensesError extends ExpensesState {
  final String message;

  ExpensesError(this.message);
}

class ExpenseActionSuccess extends ExpensesState {
  final String message;

  ExpenseActionSuccess(this.message);
}
