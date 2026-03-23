import 'package:flutter/material.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Welcome back to ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Ribhi",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFF4D00),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Set up your store and begin tracking your profits.",
          style: TextStyle(color: Color(0xFF101010), fontSize: 16),
        ),
      ],
    );
  }
}