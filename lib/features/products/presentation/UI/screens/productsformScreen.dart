import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/ProductAppbar.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/productFormBody.dart'
    show Productformbody;

class Productsformscreen extends StatelessWidget {
  final bool isEdit;
  final Product? product;

  const Productsformscreen({super.key, required this.isEdit, this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        /// Cubit الخاص بالفورم
        BlocProvider(
          create: (context) {
            final cubit = ProductFormCubit(
              context.read<ProductRepository>(),
              context.read<ProductsCubit>(),
            );

            if (isEdit && product != null) {
              cubit.loadProduct(product!);
            }

            return cubit;
          },
        ),
      ],

      child: Scaffold(
        appBar: Productappbar(isEdit: isEdit),

        backgroundColor: const Color(0xFFFFFFFF),

        body: BlocConsumer<ProductFormCubit, ProductFormState>(
          listener: (context, state) {
            if (state.success && !state.isAddingCategory) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product saved successfully"),
                  backgroundColor: Colors.green,
                ),
              );

              // Reset success state and navigate
              Future.delayed(const Duration(milliseconds: 500), () {
                context.read<ProductFormCubit>().resetState();
                Navigator.pop(context);
              });
            }

            if (state.error != null && !state.isAddingCategory) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          builder: (context, state) {
            return ModalProgressHUD(
              blur: 0.5,
              inAsyncCall: state.isLoading && !state.isAddingCategory,

              child: Productformbody(isEdit: isEdit),
            );
          },
        ),
      ),
    );
  }
}
