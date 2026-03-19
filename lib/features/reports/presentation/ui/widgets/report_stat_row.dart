import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class ReportStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color  valueColor;

  const ReportStatRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: s(context, 14),
                color: AppColors.textPrimary,
              )),
          Text(value,
              style: TextStyle(
                fontSize: s(context, 14),
                fontWeight: FontWeight.bold,
                color: valueColor,
              )),
        ],
      ),
    );
  }
}
