import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/UI/screens/productsformScreen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFD6D4D4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.name),
        
        subtitle: Text(
          "Price: ${product.sellPrice} | Qty: ${product.quantity}",
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// edit
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Productsformscreen(product: product),
                  ),
                );
              },
            ),

            /// delete
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<ProductsCubit>().deleteProduct(product.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
