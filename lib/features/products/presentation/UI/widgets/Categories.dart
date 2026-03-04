import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart' show ProductsCubit;
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_state.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final categories =
            context.read<ProductsCubit>().categories;

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {

              /// أول عنصر = All
              if (index == 0) {
                return ChoiceChip(
                  label: Textapp(
                    "All",
                    color: state.selectedCategory == null
                        ? Colors.white
                        : const Color(0xFF000000),
                  ),
                
                  selected: state.selectedCategory == null,
                
                  backgroundColor: const Color(0xFFD6D4D4),
                
                  selectedColor: const Color(0xFFF54500),
                
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: state.selectedCategory == null
                          ? const Color(0xFFF54500)
                          : const Color(0xFFD6D4D4),
                    ),
                  ),
                
                  onSelected: (_) {
                    context.read<ProductsCubit>().filterByCategory(null);
                  },
                );
              }

              final category = categories[index - 1];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  label: Textapp(category,
                      color: state.selectedCategory == category ? Colors.white : Color(0xFF000000)),
                  selected:
                      state.selectedCategory == category,
                  backgroundColor: Color(0xFFD6D4D4),
                  selectedColor: Color(0xFFF54500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: state.selectedCategory == category
                          ? Color(0xFFF54500)
                          : Color(0xFFD6D4D4),
                    ),
                  ),
                  onSelected: (_) {
                    context
                        .read<ProductsCubit>()
                        .filterByCategory(category);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}