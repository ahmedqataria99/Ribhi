import 'package:flutter/material.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Start your journey with ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: s(context, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Ribhi",
                style: TextStyle(
                  fontSize: s(context, 24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffFF4D00),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: s(context, 5)),
        Text(
          "Set up your store and begin tracking your profits.",
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: s(context, 16),
          ),
        ),
      ],
    );
  }
}
