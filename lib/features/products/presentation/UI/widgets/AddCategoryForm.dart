import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

class AddCategoryForm extends StatelessWidget {
  const AddCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 6),
            TextField(
              onChanged: cubit.updateNewCategoryName,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            /// Type
            const Textapp(
              "Type",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _unitButton(context, "Kilogram", state),
                const SizedBox(width: 10),
                _unitButton(context, "Gram", state),
                const SizedBox(width: 10),
                _unitButton(context, "Piece", state),
              ],
            ),
            const SizedBox(height: 20),
            /// Error
            if (state.error != null && state.isAddingCategory) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Textapp(
                  state.error!,
                  fontsize: 12,
                  color: Colors.red.shade800,
                ),
              ),
              const SizedBox(height: 10),
            ],
            /// Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF54500),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: state.newCategoryName.isEmpty || state.isLoading
                    ? null
                    : () {
                        cubit.addCategory();
                      },
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
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
  final selected = state.categoryType == unit.toLowerCase();
  return InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () {
      context.read<ProductFormCubit>().selectCategoryType(unit.toLowerCase());
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFF54500)
            : const Color(0xFFD6D4D4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Textapp(
        unit,
        fontsize: 12,
        color: selected ? Colors.white : Colors.black,
      ),
    ),
  );
}}