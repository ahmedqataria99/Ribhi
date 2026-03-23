
import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: const [
              TextSpan(
                text: "Start your journey with ",
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
        const SizedBox(height: 5),
        const Text(
          "Set up your store and begin tracking your profits.",
          style: TextStyle(color: Color(0xFF101010), fontSize: 16),
        ),
      ],
    );
  }
}