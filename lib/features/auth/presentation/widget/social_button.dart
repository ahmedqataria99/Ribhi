import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String? imagePath;
  final IconData? iconData;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    this.imagePath,
    this.iconData,
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
        icon: imagePath != null
            ? Image.asset(imagePath!, height: s(context, 24))
            : Icon(iconData, color: Colors.blue, size: s(context, 28)),
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
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
