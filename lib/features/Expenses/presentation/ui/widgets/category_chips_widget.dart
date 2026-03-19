import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class CategoryChipsWidget extends StatelessWidget {
  final String? selectedCategory;
  final void Function(String category) onCategoryTap;

  const CategoryChipsWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  static const _categories = [
    'Rent', 'Utilities', 'Salaries', 'Supplies', 'Maintenance', 'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Wrap(
      spacing: s(context, 8),
      runSpacing: s(context, 8),
      children: _categories.map((cat) {
        final isSelected = selectedCategory == cat;
        return GestureDetector(
          onTap: () => onCategoryTap(cat),
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
    );
  }
}