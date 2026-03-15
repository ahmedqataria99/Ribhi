import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

class QuantityAlarmFields extends StatelessWidget {
  final bool isEdit;

  const QuantityAlarmFields({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {

        return Row(
          children: [

            /// Quantity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Textapp(
                    "Quantity",
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 4),

                  TextFormField(
                    initialValue: isEdit ? state.quantity : '',

                    keyboardType: TextInputType.number,

                    onChanged: (value) {
                      context.read<ProductFormCubit>().updateQuantity(value);
                    },

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
              ),
            ),

            const SizedBox(width: 12),

            /// Alarm Limit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Textapp(
                    "Alarm limit",
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 4),

                  TextFormField(
                    initialValue: isEdit ? state.alarmLimit : '',

                    keyboardType: TextInputType.number,

                    onChanged: (value) {
                      context.read<ProductFormCubit>().updateAlarmLimit(value);
                    },

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
              ),
            ),
          ],
        );
      },
    );
  }
}