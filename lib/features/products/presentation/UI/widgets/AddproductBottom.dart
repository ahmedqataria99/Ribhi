import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Statemanegemnt/productsform_cubit.dart';
import '../../Statemanegemnt/productsform_state.dart';

class ProductFormSubmitButton extends StatelessWidget {
  final bool isEdit;

  const ProductFormSubmitButton({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {

        return SizedBox(
          width: double.infinity,
          height: 50,

          child: ElevatedButton(
            onPressed: state.isValid && !state.isLoading
                ? () {
                    if (isEdit) {
                      context.read<ProductFormCubit>().updateProduct();
                    } else {
                      context.read<ProductFormCubit>().addProduct();
                    }
                  }
                : null,

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF54500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            child: state.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    isEdit ? "Save Edits" : "Add",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }
}