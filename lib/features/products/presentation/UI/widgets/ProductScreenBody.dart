import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/Categories.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/Search.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/productcard.dart';

import '../../Statemanegemnt/products_cubit.dart';
import '../../Statemanegemnt/products_state.dart';

class Productscreenbody extends StatelessWidget {
  const Productscreenbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Search(),
          const Gap(20),
          CategoryFilterBar(),
          const Gap(20),
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                final products = state.filteredProducts;
                if (products.isEmpty) {
                  return const Center(child: Text("No Products"));
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
          
        ],
      ),
    );
  }
}
