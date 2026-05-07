import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ribhi/core/theme/app_responsive.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  Future<void> resendEmail(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification email sent again ✅")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void goToSignIn(BuildContext context) {
    Navigator.pop(context); // يرجعك للـ Sign In
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? "your email";
    final s = AppSizes.s;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(s(context, 25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(context),
              SizedBox(height: s(context, 40)),

              Text(
                "Check your email 📩",
                style: TextStyle(
                  fontSize: s(context, 22),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: s(context, 15)),

              Text(
                "We sent a verification link to:\n$email\n\nPlease verify your email before logging in.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: s(context, 16)),
              ),

              SizedBox(height: s(context, 40)),

              // 🔥 زرار إعادة الإرسال
              SizedBox(
                width: double.infinity,
                height: s(context, 55),
                child: OutlinedButton(
                  onPressed: () => resendEmail(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffFF4D00)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(s(context, 12)),
                    ),
                  ),
                  child: Text(
                    "Resend Email",
                    style: TextStyle(
                      color: const Color(0xffFF4D00),
                      fontSize: s(context, 16),
                    ),
                  ),
                ),
              ),

              SizedBox(height: s(context, 15)),

              // 🔥 زرار الرجوع للـ Login
              SizedBox(
                width: double.infinity,
                height: s(context, 55),
                child: ElevatedButton(
                  onPressed: () => goToSignIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF4D00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(s(context, 12)),
                    ),
                  ),
                  child: Text(
                    "Back to Sign In",
                    style: TextStyle(fontSize: s(context, 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final s = AppSizes.s;
    return Container(
      padding: EdgeInsets.all(s(context, 25)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE7),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0x40F54500),
            blurRadius: s(context, 20),
            offset: Offset(0, s(context, 10)),
          ),
        ],
      ),
      child: Icon(
        Icons.mark_email_unread_outlined,
        size: s(context, 60),
        color: const Color(0xffFF4D00),
      ),
    );
  }
}
