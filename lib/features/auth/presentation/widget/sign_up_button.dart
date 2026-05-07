import 'package:flutter/material.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class SignUpButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;

  /// Called with the username/store-name when sign-up succeeds.
  final void Function(String storeName)? onSignUpSuccess;

  const SignUpButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    this.onSignUpSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (emailController.text.isEmpty ||
              passwordController.text.isEmpty ||
              confirmController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill in all fields.')),
            );
            return;
          }
          if (passwordController.text != confirmController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match.')),
            );
            return;
          }

          // Notify the parent screen so it can save login state & navigate.
          onSignUpSuccess?.call(emailController.text.trim());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xffFF4D00),
          padding: EdgeInsets.symmetric(vertical: s(context, 15)),
          minimumSize: Size(double.infinity, s(context, 50)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Textapp(
          'Sign Up',
          color: Color(0xffFF4D00),
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
