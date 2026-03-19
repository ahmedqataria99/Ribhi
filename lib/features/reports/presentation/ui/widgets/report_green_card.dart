import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class ReportGreenCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;

  const ReportGreenCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: s(context, 20),
        vertical: s(context, 18),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(s(context, 14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: s(context, 13),
                    color: AppColors.background,
                  )),
              SizedBox(height: s(context, 6)),
              Text(value,
                  style: TextStyle(
                    fontSize: s(context, 22),
                    fontWeight: FontWeight.bold,
                    color: AppColors.background,
                  )),
            ],
          ),
          Image.asset(icon,
              width: s(context, 28),
              height: s(context, 28),
              color: AppColors.background),
        ],
      ),
    );
  }
}
