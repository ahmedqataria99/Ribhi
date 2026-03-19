import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class NetProfitCard extends StatelessWidget {
  final double amount;
  const NetProfitCard({super.key, required this.amount});

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
              Text(
                'Net Profit',
                style: TextStyle(
                  fontSize: s(context, 13),
                  color: AppColors.background,
                ),
              ),
              SizedBox(height: s(context, 6)),
              Text(
                '${_fmt(amount)} EGP',
                style: TextStyle(
                  fontSize: s(context, 22),
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/photo/analystic.png',
            width: s(context, 28),
            height: s(context, 28),
            color: AppColors.background,
          ),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 1000) {
      return amount.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return amount.toInt().toString();
  }
}