import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/reports/domain/entity/reports.dart';

class ReportBarChart extends StatelessWidget {
  final String            title;
  final List<DailyProfit> profits;

  const ReportBarChart({
    super.key,
    required this.title,
    required this.profits,
  });

  @override
  Widget build(BuildContext context) {
    if (profits.isEmpty) return const SizedBox.shrink();
    final s = AppSizes.s;

    final maxAmount = profits.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    final allZero   = maxAmount <= 0;
    final chartH    = s(context, 240);
    final maxBarH   = chartH - s(context, 32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: s(context, 16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            )),
        SizedBox(height: s(context, 20)),
        SizedBox(
          height: chartH,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: profits.map((p) {
              final isEmpty = p.amount <= 0;
              double barH;
              if (allZero) {
                barH = s(context, 15);
              } else {
                barH = isEmpty
                    ? s(context, 12)
                    : ((p.amount / maxAmount) * maxBarH)
                        .clamp(s(context, 12), maxBarH);
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
                    Text(p.day,
                        style: TextStyle(
                          fontSize: s(context, 12),
                          color: AppColors.textPrimary,
                        )),
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
