import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/auth/data/datasource/FirebaseauthSerivce.dart';
import 'package:ribhi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/authCubit.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/auth_state.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/signup_cubit.dart'; // 👈 مهم
import 'package:ribhi/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ribhi/features/auth/presentation/widget/sign_in_form_container.dart';
import 'package:ribhi/features/auth/presentation/widget/sign_in_header.dart';
import 'package:ribhi/features/Dashboard/presentation/ui/screens/DashboardScreen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';

class SignInScreen extends StatefulWidget {
  final String storeName;
  final double startingCapital;
  final String selectedCurrency;

  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const SignInScreen({
    super.key,
    required this.storeName,
    required this.startingCapital,
    required this.selectedCurrency,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignInPressed() {
    context.read<AuthCubit>().signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          expensesRepository: widget.expensesRepository,
          reportsRepository: widget.reportsRepository,
          productsRepository: widget.productsRepository,
          saleRepository: widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AppAuthLoginSuccess) {
          _goToDashboard();
        } else if (state is AppAuthLoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFFF4D00),
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AppAuthLoginLoading;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          const SignInHeader(),
                          Gap.expand(20)
                      
                          ],
                      ),
                    ),
                    SignInFormContainer(
                            emailController: emailController,
                            passwordController: passwordController,
                            isPasswordHidden: isPasswordHidden,
                            isLoading: isLoading,
                      
                            onPasswordVisibilityToggle: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                      
                            onSignInPressed: isLoading ? () {} : _onSignInPressed,
                      
                            onCreateAccountPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => SignupCubit(
                                    AuthRepositoryImpl(
                                      authService: FirebaseAuthService(),
                                    ),
                                  ),
                                  child: SignUpScreen(
                                    storeName: widget.storeName,
                                    startingCapital: widget.startingCapital,
                                    currency: widget.selectedCurrency,
                                    expensesRepository: widget.expensesRepository,
                                    reportsRepository: widget.reportsRepository,
                                    productsRepository: widget.productsRepository,
                                    saleRepository: widget.saleRepository,
                                    productLocalDataSource: widget.productLocalDataSource,
                                  ),
                                ),
                              ),
                            );
                          },),
                        
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}