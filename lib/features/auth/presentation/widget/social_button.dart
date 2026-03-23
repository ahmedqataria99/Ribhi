import 'package:flutter/material.dart';

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
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: imagePath != null
            ? Image.asset(imagePath!, height: 24)
            : Icon(iconData, color: Colors.blue, size: 28),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
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