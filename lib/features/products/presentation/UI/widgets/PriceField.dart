import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

class PriceFields extends StatelessWidget {
  final bool isEdit;

  const PriceFields({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        return Row(
          children: [
            /// Purchase Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Textapp(
                    "Purchase price",
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),

                  SizedBox(height: s(context, 4)),

                  TextFormField(
                    initialValue: isEdit ? state.costPrice : '',

                    keyboardType: TextInputType.number,

                    onChanged: (value) {
                      context.read<ProductFormCubit>().updateCostPrice(value);
                    },

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
                ],
              ),
            ),

            SizedBox(width: s(context, 12)),

            /// Selling Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Textapp(
                    "Selling price",
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),

                  SizedBox(height: s(context, 4)),

                  TextFormField(
                    initialValue: isEdit ? state.sellPrice : '',

                    keyboardType: TextInputType.number,

                    onChanged: (value) {
                      context.read<ProductFormCubit>().updateSellPrice(value);
                    },

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
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
