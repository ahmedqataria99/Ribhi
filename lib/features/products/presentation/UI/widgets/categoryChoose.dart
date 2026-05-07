import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
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
    required BuildContext context,
  }) {
    final s = AppSizes.s;
    return InkWell(
      borderRadius: BorderRadius.circular(s(context, 8)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: s(context, 12),
          vertical: s(context, 6),
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF54500) : const Color(0xFFD6D4D4),
          borderRadius: BorderRadius.circular(s(context, 8)),
          border: Border.all(
            color: selected ? const Color(0xFFF54500) : const Color(0xFFD6D4D4),
          ),
        ),
        child: Textapp(label, color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
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
                  SizedBox(height: s(context, 6)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...categories.map((category) {
                        final selected = formState.category == category;
                        return buildCategoryChip(
                          label: category,
                          selected: selected,
                          context: context,
                          onTap: () {
                            context.read<ProductFormCubit>().selectCategory(
                              category,
                            );
                          },
                        );
                      }),

                      /// Other +
                      buildCategoryChip(
                        label: "Other +",
                        selected: formState.category == "Other",
                        context: context,
                        onTap: () {
                          context.read<ProductFormCubit>().selectCategory(
                            "Other",
                          );
                        },
                      ),
                    ],
                  ),

                  /// Add Category Form
                  if (formState.category == "Other") ...[
                    SizedBox(height: s(context, 20)),
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
