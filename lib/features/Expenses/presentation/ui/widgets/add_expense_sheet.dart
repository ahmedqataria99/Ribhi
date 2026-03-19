import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/entity/Expenses.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _descController   = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;

  static const _categories = [
    'Rent', 'Utilities', 'Salaries', 'Supplies', 'Maintenance', 'Other',
  ];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final title      = _descController.text.trim();
    final amountText = _amountController.text.trim();
    if (title.isEmpty || amountText.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    context.read<ExpensesCubit>().addExpense(Expense(
      title: title,
      amount: amount,
      category: _selectedCategory!,
      date: DateTime.now(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(s(context, 20)),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(s(context, 20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add expense',
              style: TextStyle(
                fontSize: s(context, 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: s(context, 16)),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [],
              style: TextStyle(fontSize: s(context, 14)),
              decoration: InputDecoration(
                hintText: 'Expense description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(s(context, 10)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: s(context, 14),
                  vertical: s(context, 12),
                ),
              ),
            ),
            SizedBox(height: s(context, 12)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(fontSize: s(context, 14)),
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(s(context, 10)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: s(context, 14),
                  vertical: s(context, 12),
                ),
              ),
            ),
            SizedBox(height: s(context, 12)),
            Wrap(
              spacing: s(context, 8),
              runSpacing: s(context, 8),
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: s(context, 14),
                      vertical: s(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.orange : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(s(context, 20)),
                    ),
                    child: Text(
                      '+ $cat',
                      style: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                        fontSize: s(context, 13),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: s(context, 20)),
            SizedBox(
              width: double.infinity,
              height: s(context, 48),
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s(context, 20)),
                  ),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: s(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}