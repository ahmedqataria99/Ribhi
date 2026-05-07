import 'package:flutter/material.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/auth/presentation/widget/already_haveAccount_button.dart';
import 'package:ribhi/features/auth/presentation/widget/custom_text_field.dart';
import 'package:ribhi/features/auth/presentation/widget/or_divider.dart';
import 'package:ribhi/features/auth/presentation/widget/sign_up_button.dart';
import 'package:ribhi/features/auth/presentation/widget/social_auth_button.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool isPasswordHidden;
  final bool isConfirmHidden;
  final VoidCallback togglePasswordVisibility;
  final VoidCallback toggleConfirmVisibility;
  final String storeName;
  final double startingCapital;
  final String currency;

  /// Called with the store name after a successful sign-up.
  final void Function(String storeName)? onSignUpSuccess;

  // Repositories forwarded to AlreadyHaveAccountButton → SignInScreen
  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const SignUpForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.isPasswordHidden,
    required this.isConfirmHidden,
    required this.togglePasswordVisibility,
    required this.toggleConfirmVisibility,
    required this.storeName,
    required this.startingCapital,
    required this.currency,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
    this.onSignUpSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Container(
      padding: EdgeInsets.all(s(context, 20)),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xffFF4D00),
        borderRadius: BorderRadius.only(topRight: Radius.circular(120)),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Textapp(
              'Sign Up',
              fontsize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: s(context, 20)),
          CustomTextField(
            controller: emailController,
            hintText: 'User Name',
            prefixIcon: Icons.email,
          ),
          SizedBox(height: s(context, 15)),
          CustomTextField(
            controller: passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock,
            obscureText: isPasswordHidden,
            suffixIcon: IconButton(
              onPressed: togglePasswordVisibility,
              icon: Icon(
                isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: s(context, 15)),
          CustomTextField(
            controller: confirmController,
            hintText: 'Confirm Password',
            prefixIcon: Icons.lock,
            obscureText: isConfirmHidden,
            suffixIcon: IconButton(
              onPressed: toggleConfirmVisibility,
              icon: Icon(
                isConfirmHidden ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: s(context, 25)),
          SignUpButton(
            emailController: emailController,
            passwordController: passwordController,
            confirmController: confirmController,
            onSignUpSuccess: onSignUpSuccess,
          ),
          SizedBox(height: s(context, 20)),
          const OrDivider(),
          SizedBox(height: s(context, 20)),
          AlreadyHaveAccountButton(
            storeName: storeName,
            startingCapital: startingCapital,
            currency: currency,
            expensesRepository: expensesRepository,
            reportsRepository: reportsRepository,
            productsRepository: productsRepository,
            saleRepository: saleRepository,
            productLocalDataSource: productLocalDataSource,
          ),
          SizedBox(height: s(context, 12)),
          SocialButton(
            text: 'Continue with Google',
            icon: Image.asset(
              'assets/photo/flat-color-icons_google.png',
              height: 24,
            ),
            onPressed: () {},
          ),
          SizedBox(height: s(context, 10)),
          SocialButton(
            text: 'Continue with Facebook',
            icon: const Icon(Icons.facebook, color: Colors.blue, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
