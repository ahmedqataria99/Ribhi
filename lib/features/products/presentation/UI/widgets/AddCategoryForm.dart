import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

class AddCategoryForm extends StatelessWidget {
  const AddCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        final cubit = context.read<ProductFormCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Category Name
            const Textapp(
              "Category Name",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            SizedBox(height: s(context, 6)),
            TextField(
              onChanged: cubit.updateNewCategoryName,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(s(context, 8)),
                  ),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(s(context, 8)),
                  ),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: s(context, 20)),

            /// Type
            const Textapp(
              "Type",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            SizedBox(height: s(context, 10)),
            Row(
              children: [
                _unitButton(context, "Kilogram", state),
                SizedBox(width: s(context, 10)),
                _unitButton(context, "Gram", state),
                SizedBox(width: s(context, 10)),
                _unitButton(context, "Piece", state),
              ],
            ),
            SizedBox(height: s(context, 20)),

            /// Error
            if (state.error != null && state.isAddingCategory) ...[
              Container(
                padding: EdgeInsets.all(s(context, 8)),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(s(context, 6)),
                ),
                child: Textapp(
                  state.error!,
                  fontsize: 12,
                  color: Colors.red.shade800,
                ),
              ),
              SizedBox(height: s(context, 10)),
            ],

            /// Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF54500),
                  padding: EdgeInsets.symmetric(vertical: s(context, 12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s(context, 8)),
                  ),
                ),
                onPressed: state.newCategoryName.isEmpty || state.isLoading
                    ? null
                    : () {
                        cubit.addCategory();
                      },
                child: state.isLoading
                    ? SizedBox(
                        height: s(context, 20),
                        width: s(context, 20),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Textapp(
                        "Add Category",
                        color: Colors.white,
                        fontsize: 14,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _unitButton(
    BuildContext context,
    String unit,
    ProductFormState state,
  ) {
    final s = AppSizes.s;
    final selected = state.categoryType == unit.toLowerCase();
    return InkWell(
      borderRadius: BorderRadius.circular(s(context, 8)),
      onTap: () {
        context.read<ProductFormCubit>().selectCategoryType(unit.toLowerCase());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: s(context, 12),
          vertical: s(context, 6),
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF54500) : const Color(0xFFD6D4D4),
          borderRadius: BorderRadius.circular(s(context, 8)),
        ),
        child: Textapp(
          unit,
          fontsize: 12,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
