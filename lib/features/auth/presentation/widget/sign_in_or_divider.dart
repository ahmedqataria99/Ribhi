import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: s(context, 20)),
      child: Row(
        children: [
          Expanded(child: Container(height: 2, color: Colors.white)),
          SizedBox(width: s(context, 12)),
          Text(
            "OR",
            style: TextStyle(color: Colors.white, fontSize: s(context, 14)),
          ),
          SizedBox(width: s(context, 12)),
          Expanded(child: Container(height: 2, color: Colors.white)),
        ],
      ),
    );
  }
}
