import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class StatCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String value;
  final Color valueColor;

  const StatCard({
    super.key,
    required this.imagePath,
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
        Row(
          children: [
            Image.asset(imagePath, width: s(context, 20), height: s(context, 20)),
            SizedBox(width: s(context, 8)),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: s(context, 13),
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: s(context, 8)),
        Text(
          value,
          style: TextStyle(
            fontSize: s(context, 16),
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}