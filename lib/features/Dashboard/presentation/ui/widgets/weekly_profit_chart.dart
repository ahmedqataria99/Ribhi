import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Dashboard/domain/entity/DashboardStats.dart';

class WeeklyProfitChart extends StatelessWidget {
  final List<DailyProfit> profits;
  const WeeklyProfitChart({super.key, required this.profits});

  @override
  Widget build(BuildContext context) {
    if (profits.isEmpty) return const SizedBox.shrink();

    final s = AppSizes.s;
    final maxAmount = profits.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    final allZero   = maxAmount <= 0;
    final chartH    = s(context, 240);
    final maxBarH   = chartH - s(context, 32); // 32 = label area

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profits – Last 7 Days',
          style: TextStyle(
            fontSize: s(context, 16),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: s(context, 20)),
        SizedBox(
          width: double.infinity,
          height: chartH,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: profits.map((profit) {
              final isEmpty = profit.amount <= 0;
              double barH;
              if (allZero) {
                barH = s(context, 15);
              } else {
                final ratio = profit.amount / maxAmount;
                barH = isEmpty
                    ? s(context, 12)
                    : (ratio * maxBarH).clamp(s(context, 12), maxBarH);
              }

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: s(context, 5)),
                      child: Container(
                        height: barH,
                        decoration: BoxDecoration(
                          color: isEmpty ? AppColors.red : AppColors.green,
                          borderRadius: BorderRadius.circular(s(context, 8)),
                        ),
                      ),
                    ),
                    SizedBox(height: s(context, 10)),
                    Text(
                      profit.day,
                      style: TextStyle(
                        fontSize: s(context, 12),
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}