import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class Productappbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEdit;

  const Productappbar({super.key, required this.isEdit});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Padding(
      padding: EdgeInsets.all(s(context, 16.0)),
      child: Row(
        children: [
          Text(
            isEdit ? "Edit product" : "Add a new product",
            style: TextStyle(
              fontSize: s(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
