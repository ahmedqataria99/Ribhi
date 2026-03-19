import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class ReportMiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color  valueColor;

  const ReportMiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: s(context, 13),
              color: AppColors.textSecondary,
            )),
        SizedBox(height: s(context, 4)),
        Text(value,
            style: TextStyle(
              fontSize: s(context, 16),
              fontWeight: FontWeight.bold,
              color: valueColor,
            )),
      ],
    );
  }
}
