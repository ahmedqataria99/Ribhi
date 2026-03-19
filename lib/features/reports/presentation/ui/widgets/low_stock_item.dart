import 'package:flutter/material.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/reports/domain/entity/reports.dart';

class LowStockItem extends StatelessWidget {
  final LowStockProduct product;
  const LowStockItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Container(
      margin: EdgeInsets.only(bottom: s(context, 10)),
      padding: EdgeInsets.symmetric(
        horizontal: s(context, 14),
        vertical: s(context, 12),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBorder,
        borderRadius: BorderRadius.circular(s(context, 14)),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/photo/emojione-v1_warning.png',
            width: s(context, 22),
            height: s(context, 22),
          ),
          SizedBox(width: s(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: TextStyle(
                      fontSize: s(context, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                SizedBox(height: s(context, 2)),
                Text(
                  'Available: ${product.available} | Minimum: ${product.minimum}',
                  style: TextStyle(
                    fontSize: s(context, 12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: s(context, 10),
              vertical: s(context, 4),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: product.outOfStock
                    ? AppColors.red
                    : AppColors.textSecondary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(s(context, 20)),
            ),
            child: Text(
              product.outOfStock ? 'Out of stock' : 'Low',
              style: TextStyle(
                fontSize: s(context, 11),
                fontWeight: FontWeight.w500,
                color: product.outOfStock
                    ? AppColors.red
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
