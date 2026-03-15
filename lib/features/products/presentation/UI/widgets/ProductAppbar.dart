import 'package:flutter/material.dart';

class Productappbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEdit;

  const Productappbar({super.key, required this.isEdit});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            isEdit ? "Edit product" : "Add a new product",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
          
        ],
      ),
    );
  }
}