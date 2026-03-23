import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_state.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final categories = state.categories;
        final selectedCategory = state.selectedCategory;

        final allCategories = ["All", ...categories];

        return SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,

            /// المسافة بين العناصر
            separatorBuilder: (_, __) => const SizedBox(width: 16),

            itemBuilder: (context, index) {
              final category = allCategories[index];

              final isSelected = category == "All"
              ? selectedCategory == null ||
                  selectedCategory == "" ||
                  selectedCategory == "All"
              : selectedCategory?.trim().toLowerCase() ==
                  category.trim().toLowerCase();

              return GestureDetector(
                onTap: () {
                  context.read<ProductsCubit>().filterByCategory(
                        category == "All" ? null : category,
                      );
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    // vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF54500)
                        : const Color(0xFFD6D4D4),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Center(
                    child: Textapp(
                      category,
                      fontWeight: FontWeight.w400,
                      fontsize: 14,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF000000),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}