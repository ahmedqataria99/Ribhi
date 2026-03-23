import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Container(height: 2, color: Colors.white)),
          const SizedBox(width: 12),
          const Text("OR", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 2, color: Colors.white)),
        ],
      ),
    );
  }
}