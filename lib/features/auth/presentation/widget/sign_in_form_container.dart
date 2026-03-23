// File: sign_in_form_container.dart
import 'package:flutter/material.dart';
import 'package:ribhi/core/constant/text.dart';
import 'custom_text_field.dart';
import 'social_button.dart';
import 'or_divider.dart';

class SignInFormContainer extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordHidden;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onSignInPressed;
  final VoidCallback onCreateAccountPressed;

  const SignInFormContainer({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordHidden,
    this.isLoading = false,
    required this.onPasswordVisibilityToggle,
    required this.onSignInPressed,
    required this.onCreateAccountPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      constraints:BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ) ,
      decoration: const BoxDecoration(
        color: Color(0xffFF4D00),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(120),
        ),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Textapp(
              'Sign In',
              fontsize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          CustomTextField(
            controller: emailController,
            hintText: "User Name",
            obscureText: false,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: passwordController,
            hintText: "Password",
            obscureText: isPasswordHidden,
            prefixIcon: Icons.lock,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: onPasswordVisibilityToggle,
            )),
          
          
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: isLoading ? null : onSignInPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xffFF4D00),
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xffFF4D00),
                    ),
                  )
                : const Textapp("Sign In", color: Color(0xffFF4D00),fontsize: 16,fontWeight: FontWeight.bold,),
          ),
          const SizedBox(height: 20),
          const OrDivider(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onCreateAccountPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xffFF4D00),
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )
            ),
            child: const Textapp(
              "Create an account",
              color: Color.fromARGB(255, 0, 0, 0),
              fontsize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SocialButton(
            text: "Continue with Google",
            imagePath: "assets/photo/flat-color-icons_google.png",
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          SocialButton(
            text: "Continue with Facebook",
            iconData: Icons.facebook,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}