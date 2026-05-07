import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return SizedBox(
      width: double.infinity,
      height: s(context, 42),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: s(context, 14),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xffFF4D00),
          padding: EdgeInsets.symmetric(vertical: s(context, 15)),
          minimumSize: Size(double.infinity, s(context, 50)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
