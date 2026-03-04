import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ribhi/core/constant/text.dart';

import '../../Statemanegemnt/products_cubit.dart';
import '../../Statemanegemnt/products_state.dart';

import '../widgets/ProductScreenBody.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Expecting ProductsCubit provided higher in widget tree (e.g. main.dart)
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Textapp("Product deleted successfully")),
            );
          }

          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Textapp(state.error!)));
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            blur: 0.5,
            inAsyncCall: state.isLoading || state.isDeleting,
            child: const Productscreenbody(),
          );
        },
      ),
    );
  }
}
