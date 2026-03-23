import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Initialization/data/datasource/SettingLocalData.dart';
import 'package:ribhi/features/Initialization/data/model/settingModel.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/authCubit.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/auth_state.dart';
import 'package:ribhi/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:ribhi/features/Dashboard/presentation/ui/screens/DashboardScreen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';

class SplashScreen extends StatefulWidget {
  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;
  final SettingsLocalDataSource settingsDataSource;

  const SplashScreen({
    super.key,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
    required this.settingsDataSource,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000), // ⏳ أطول
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();

    // ⏳ يقعد شوية
    Future.delayed(const Duration(milliseconds: 5500), () {
      if (mounted) {
        _controller.reverse();
      }
    });

    // 🚀 بعد الأنيميشن
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        context.read<AuthCubit>().checkLoginStatus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          expensesRepository: widget.expensesRepository,
          reportsRepository: widget.reportsRepository,
          productsRepository: widget.productsRepository,
          saleRepository: widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
        ),
      ),
    );
  }

  Future<void> _navigateToSignIn() async {
    SettingsModel? settings;
    try {
      settings = await widget.settingsDataSource.get();
    } catch (_) {}

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignInScreen(
          storeName: settings?.storeName ?? '',
          startingCapital: settings?.initialCapital ?? 0,
          selectedCurrency: settings?.currency ?? 'EGP',
          expensesRepository: widget.expensesRepository,
          reportsRepository: widget.reportsRepository,
          productsRepository: widget.productsRepository,
          saleRepository: widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AppAuthAuthenticated) {
          _navigateToDashboard();
        } else if (state is AppAuthUnauthenticated) {
          _navigateToSignIn();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {

              // 🌫️ البلور بس أثناء الخروج
              double blur = 0;
              if (_controller.status == AnimationStatus.reverse) {
                blur = (1 - _fadeAnim.value) * 15;
              }

              return Opacity(
                opacity: _fadeAnim.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnim.value.dy * 200),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: Image.asset(
              "assets/photo/Ribhi.png",
              width: 130,
              height: 130,
            ),
          ),
        ),
      ),
    );
  }
}