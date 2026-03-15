import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

class ProductNameField extends StatelessWidget {
  final bool isEdit;

  const ProductNameField({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Textapp(
              "Product name",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),

            const SizedBox(height: 4),

            TextFormField(
              initialValue: isEdit ? state.name : '',

              textDirection: TextDirection.ltr,

              onChanged: (value) {
                context.read<ProductFormCubit>().updateName(value);
              },

              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
              ],

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
          ],
        );
      },
    );
  }
}