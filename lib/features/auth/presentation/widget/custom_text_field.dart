import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white, fontSize: s(context, 16)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70, fontSize: s(context, 14)),
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        suffixIcon: suffixIcon,
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 12)),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 145, 145, 145),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 12)),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        fillColor: const Color(0xffFF4D00),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 12)),
        ),
      ),
    );
  }
}
