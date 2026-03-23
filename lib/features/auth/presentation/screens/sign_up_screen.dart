import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/signup_cubit.dart';
import 'package:ribhi/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:ribhi/features/auth/presentation/widget/sign_up_form_container.dart';
import 'package:ribhi/features/auth/presentation/widget/sign_up_header.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';

class SignUpScreen extends StatefulWidget {
  final String storeName;
  final double startingCapital;
  final String currency;

  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const SignUpScreen({
    super.key,
    required this.storeName,
    required this.startingCapital,
    required this.currency,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EmailVerificationScreen(),
            ),
          );
        } else if (state is SignupInFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const SignUpHeader(),
                
                  ],
                ),
              ),
                    Gap.expand(20),
                    SignUpForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmController: confirmController,
                      isPasswordHidden: isPasswordHidden,
                      isConfirmHidden: isConfirmHidden,
                                    
                      togglePasswordVisibility: () {
                        setState(() => isPasswordHidden = !isPasswordHidden);
                      },
                      toggleConfirmVisibility: () {
                        setState(() => isConfirmHidden = !isConfirmHidden);
                      },
                                    
                      storeName: widget.storeName,
                      startingCapital: widget.startingCapital,
                      currency: widget.currency,
                      expensesRepository: widget.expensesRepository,
                      reportsRepository: widget.reportsRepository,
                      productsRepository: widget.productsRepository,
                      saleRepository: widget.saleRepository,
                      productLocalDataSource: widget.productLocalDataSource,
                                    
                      onSignUpSuccess: (_) {
                        context.read<SignupCubit>().createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },
                    ),
                  
            ],
          ),
        ),
      ),
    );
  }
}