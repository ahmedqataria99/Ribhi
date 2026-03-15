import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/features/products/presentation/UI/screens/productsformScreen.dart';

import '../../Statemanegemnt/products_cubit.dart';
import '../../Statemanegemnt/products_state.dart';

import '../widgets/ProductScreenBody.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProductsScreenView();
  }
}

class _ProductsScreenView extends StatelessWidget {
  const _ProductsScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.category, color: Color(0xFFF54500)),
            onPressed: () {
              showCategoriesPopup(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ProductsCubit>(),
                child: const Productsformscreen(isEdit: false),
              ),
            ),
          );
        },

        child: CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFF16A34A),
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),

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

void showCategoriesPopup(BuildContext context) {
  final cubit = context.read<ProductsCubit>();
  final categories = cubit.state.categories;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Categories"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return ListTile(
                leading: const Icon(Icons.category),

                /// اختيار الكاتيجوري
                title: Text(category),
                onTap: () {
                  cubit.filterByCategory(category);
                  Navigator.pop(context);
                },

                /// ازرار التعديل و الحذف
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// edit
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                        showEditCategoryDialog(context, category, cubit);
                      },
                    ),

                    /// delete
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        cubit.deleteCategory(category);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void showEditCategoryDialog(
  BuildContext context,
  String oldCategory,
  ProductsCubit cubit,
) {
  final controller = TextEditingController(text: oldCategory);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Textapp("Edit Category" , fontWeight: FontWeight.bold,),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
                      hintText: "Enter new category name",
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
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              
            ),
            child: const Textapp("Cancel", fontsize: 12,fontWeight: FontWeight.w500,),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              
              backgroundColor: Color(0xFFF54500),
            ),
            child: const Textapp(
              "Save", 
              fontsize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,),
            onPressed: () {
              cubit.updateCategory(oldCategory, controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
