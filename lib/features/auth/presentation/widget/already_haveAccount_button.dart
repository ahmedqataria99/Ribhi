import 'package:flutter/material.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';

class AlreadyHaveAccountButton extends StatelessWidget {
  final String storeName;
  final double startingCapital;
  final String currency;

  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const AlreadyHaveAccountButton({
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
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return SizedBox(
      width: double.infinity,
      height: s(context, 42),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignInScreen(
                storeName: storeName,
                startingCapital: startingCapital,
                selectedCurrency: currency,
                expensesRepository: expensesRepository,
                reportsRepository: reportsRepository,
                productsRepository: productsRepository,
                saleRepository: saleRepository,
                productLocalDataSource: productLocalDataSource,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xffFF4D00),
          padding: EdgeInsets.symmetric(vertical: s(context, 15)),
          minimumSize: Size(double.infinity, s(context, 45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Textapp(
          'Already have an account',
          color: Colors.black,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
