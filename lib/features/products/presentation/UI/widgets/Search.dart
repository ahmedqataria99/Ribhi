import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      onChanged: (value) {
        context.read<ProductsCubit>().search(value);

        /// تحديث ال UI عشان يظهر او يختفي زرار X
        setState(() {});
      },

      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: 'Search..',
        prefixIcon: const Icon(Icons.search),

        /// يظهر فقط لو فيه نص
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controller.clear();

                  context.read<ProductsCubit>().search("");

                  setState(() {});
                },
                icon: const Icon(Icons.clear),
              )
            : null,

        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
