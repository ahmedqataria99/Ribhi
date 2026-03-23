import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void goToSignIn(BuildContext context) {
    Navigator.pop(context); // يرجعك للـ Sign In
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? "your email";

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              const SizedBox(height: 40),

              const Text(
                "Check your email 📩",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Text(
                "We sent a verification link to:\n$email\n\nPlease verify your email before logging in.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // 🔥 زرار إعادة الإرسال
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () => resendEmail(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffFF4D00)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Resend Email",
                    style: TextStyle(color: Color(0xffFF4D00)),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🔥 زرار الرجوع للـ Login
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => goToSignIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF4D00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Back to Sign In"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() => Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFE7),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0x40F54500),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.mark_email_unread_outlined,
          size: 60,
          color: Color(0xffFF4D00),
        ),
      );
}