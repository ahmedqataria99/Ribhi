import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class ExpenseDistributionWidget extends StatelessWidget {
  final Map<String, double> distribution;
  final double total;

  const ExpenseDistributionWidget({
    super.key,
    required this.distribution,
    required this.total,
  });

  static const _categoryColors = {
    'Other':       AppColors.categoryOther,
    'Rent':        AppColors.categoryRent,
    'Utilities':   AppColors.categoryUtilities,
    'Supplies':    AppColors.categorySupplies,
    'Salaries':    AppColors.categorySalaries,
    'Maintenance': AppColors.categoryMaintenance,
  };

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) return const SizedBox.shrink();
    final s = AppSizes.s;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expense distribution',
          style: TextStyle(
            fontSize: s(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: s(context, 14)),
        ...distribution.entries.map((entry) {
          final percent = total > 0 ? (entry.value / total) : 0.0;
          final color = _categoryColors[entry.key] ?? AppColors.textSecondary;

          return Padding(
            padding: EdgeInsets.only(bottom: s(context, 12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: s(context, 13),
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: s(context, 4)),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: AppColors.cardBorder,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 7,
                        ),
                      ),
                    ),
                    SizedBox(width: s(context, 8)),
                    SizedBox(
                      width: s(context, 32),
                      child: Text(
                        '${(percent * 100).round()}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: s(context, 12),
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}