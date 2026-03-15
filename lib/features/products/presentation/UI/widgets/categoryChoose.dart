import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_state.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/AddCategoryForm.dart';
import '../../Statemanegemnt/productsform_state.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  Widget buildCategoryChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF54500) : const Color(0xFFD6D4D4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFFF54500) : const Color(0xFFD6D4D4),
          ),
        ),
        child: Textapp(
          label,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, productsState) {
        final categories = productsState.categories;
        return BlocBuilder<ProductFormCubit, ProductFormState>(
          builder: (context, formState) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Textapp(
                    "Category",
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...categories.map((category) {
                        final selected = formState.category == category;
                        return buildCategoryChip(
                          label: category,
                          selected: selected,
                          onTap: () {
                            context.read<ProductFormCubit>()
                                .selectCategory(category);
                          },
                        );
                      }),
                      /// Other +
                      buildCategoryChip(
                        label: "Other +",
                        selected: formState.category == "Other",
                        onTap: () {
                          context.read<ProductFormCubit>()
                              .selectCategory("Other");
                        },
                      ),
                    ],
                  ),
                  /// Add Category Form
                  if (formState.category == "Other") ...[
                    const SizedBox(height: 20),
                    const AddCategoryForm(),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}