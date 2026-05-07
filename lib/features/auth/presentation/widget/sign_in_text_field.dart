import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isObscure,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: Colors.white, fontSize: s(context, 16)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70, fontSize: s(context, 14)),
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixPressed,
                icon: Icon(suffixIcon, color: Colors.white),
              )
            : null,
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 12)),
          borderSide: const BorderSide(color: Color(0xFF7E7E7E), width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 12)),
        ),
      ),
    );
  }
}
