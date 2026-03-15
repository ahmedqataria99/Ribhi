import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/UI/screens/productsformScreen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: ColorScheme.fromSwatch(cardColor: Color.fromARGB(255, 0, 0, 0)).primary.withOpacity(0.5),
      color: Color(0xFFD6D4D4),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Textapp(
          product.name,
          fontWeight: FontWeight.w500,
          fontsize: 16,
          ),
        
        subtitle: Textapp(
          "Price: ${product.sellPrice} | Qty: ${product.quantity} ${product.categoryType}",
          color: Color(0xff101010),
          fontWeight: FontWeight.w400,
          fontsize: 12,
        ),

        trailing: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// edit
                IconButton(
                  iconSize: 20,
                  icon: SvgPicture.asset("assets/svg/edit.svg"),
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
                /// delete
                IconButton(
                  iconSize: 20,
                  icon: SvgPicture.asset("assets/svg/delete.svg"),
                  onPressed: () {
                    context.read<ProductsCubit>().deleteProduct(product.id!);
                  },
                ),
              ],
            ),
            Gap(8)
          ],
        ),
      ),
    );
  }
}
