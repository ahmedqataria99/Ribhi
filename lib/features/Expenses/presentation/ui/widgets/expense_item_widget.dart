import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:ribhi/features/Expenses/presentation/ui/widgets/edit_expense_sheet.dart';

class ExpenseItemWidget extends StatelessWidget {
  final Expense expense;
  const ExpenseItemWidget({super.key, required this.expense});

  void _showDeleteDialog(BuildContext context) {
    final s = AppSizes.s;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => BlocProvider.value(
        value: context.read<ExpensesCubit>(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: s(context, 24)),
          child: SizedBox(
            width: 326,
            height: 37,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ExpensesCubit>().deleteExpense(expense.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(s(context, 10)),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s(context, 15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ExpensesCubit>(),
        child: EditExpenseSheet(expense: expense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Container(
      margin: EdgeInsets.only(bottom: s(context, 10)),
      padding: EdgeInsets.symmetric(
        horizontal: s(context, 16),
        vertical: s(context, 14),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBorder,
        borderRadius: BorderRadius.circular(s(context, 14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      expense.title,
                      style: TextStyle(
                        fontSize: s(context, 15),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: s(context, 8)),
                    Text(
                      '${expense.amount.toInt()} EGP',
                      style: TextStyle(
                        fontSize: s(context, 15),
                        fontWeight: FontWeight.bold,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: s(context, 8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: s(context, 10),
                    vertical: s(context, 3),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(s(context, 20)),
                  ),
                  child: Text(
                    expense.category,
                    style: TextStyle(
                      fontSize: s(context, 12),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showEditDialog(context),
            icon: Icon(Icons.edit_outlined, size: s(context, 20)),
            color: AppColors.textPrimary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: s(context, 14)),
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: Icon(Icons.delete_outline, size: s(context, 20)),
            color: AppColors.textPrimary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}