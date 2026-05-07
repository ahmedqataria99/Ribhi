import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/UI/screens/productsformScreen.dart';

class ProductCard extends StatelessWidget {
  final void Function(int) onpressed;
  final Product product;

  const ProductCard({super.key, required this.product, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Card(
      color: AppColors.cardBorder,
      margin: EdgeInsets.symmetric(vertical: s(context, 4)),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        title: Textapp(
          product.name,
          fontWeight: FontWeight.w400,
          fontsize: 16,
        ),
        subtitle: Textapp(
          'Price: ${product.sellPrice} | Qty: ${product.quantity} ${product.categoryType ?? ''}',
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w300,
          fontsize: 12,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Edit ──
            IconButton(
              iconSize: s(context, 20),
              icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProductsCubit>(),
                      child: Productsformscreen(
                        product: product,
                        isEdit: true,
                      ),
                    ),
                  ),
                );
              },
            ),
            // ── Delete ──
            IconButton(
              iconSize: s(context, 20),
              icon: const Icon(Icons.delete_outline, color: AppColors.textPrimary),
              onPressed: (){
                onpressed(product.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}