import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:ribhi/features/Expenses/presentation/ui/screens/ExpensesScreen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/presentation/UI/screens/ProductsScreen.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_cubit.dart';
import 'package:ribhi/features/reports/presentation/ui/screens/ReportsScreen.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';
import 'package:ribhi/features/sales/presentation/cubit/sales_cubit.dart';
import 'package:ribhi/features/sales/presentation/cubit/sales_state.dart';

class _AppIcons {
  static const home     = 'assets/photo/iconamoon_category-light.png';
  static const product  = 'assets/photo/fluent-mdl2_product.png';
  static const sales    = 'assets/photo/Frame 197 (1).png';
  static const expenses = 'assets/photo/iconoir_wallet.png';
  static const chart    = 'assets/photo/carbon_analytics.png';
}

class _NavRoute extends PageRouteBuilder {
  _NavRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) {
            final curved = CurvedAnimation(
                parent: anim, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
            return SlideTransition(
              position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
              child: FadeTransition(opacity: curved, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 280),
        );
}

class SalesScreen extends StatelessWidget {
  final SaleRepositoryImpl        saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;
  final ExpenseRepository          expensesRepository;
  final ReportsRepositoryImpl      reportsRepository;
  final ProductRepositoryImpl      productsRepository;

  const SalesScreen({
    super.key,
    required this.saleRepository,
    required this.productLocalDataSource,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SalesCubit(saleRepository, productLocalDataSource),
      child: _SalesView(
        saleRepository:         saleRepository,
        productLocalDataSource: productLocalDataSource,
        expensesRepository:     expensesRepository,
        reportsRepository:      reportsRepository,
        productsRepository:     productsRepository,
      ),
    );
  }
}

class _SalesView extends StatelessWidget {
  final SaleRepositoryImpl        saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;
  final ExpenseRepository          expensesRepository;
  final ReportsRepositoryImpl      reportsRepository;
  final ProductRepositoryImpl      productsRepository;

  const _SalesView({
    required this.saleRepository,
    required this.productLocalDataSource,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
  });

  static const int _activeIndex = 2;

  void _navigateTo(BuildContext context, int i) {
    if (i == _activeIndex) return;
    if (i == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (i == 1) {
      Navigator.pushReplacement(context, _NavRoute(
        page: ProductsScreen(
          expensesRepository:     expensesRepository,
          reportsRepository:      reportsRepository,
          productsRepository:     productsRepository,
          saleRepository:         saleRepository,
          productLocalDataSource: productLocalDataSource,
        ),
      ));
    } else if (i == 3) {
      Navigator.pushReplacement(context, _NavRoute(
        page: BlocProvider(
          create: (_) => ExpensesCubit(repository: expensesRepository)..loadExpenses(),
          child: ExpensesScreen(
            expensesRepository:     expensesRepository,
            reportsRepository:      reportsRepository,
            productsRepository:     productsRepository,
            saleRepository:         saleRepository,
            productLocalDataSource: productLocalDataSource,
          ),
        ),
      ));
    } else if (i == 4) {
      Navigator.pushReplacement(context, _NavRoute(
        page: BlocProvider(
          create: (_) => ReportsCubit(repository: reportsRepository),
          child: ReportsScreen(
            reportsRepository:      reportsRepository,
            expensesRepository:     expensesRepository,
            productsRepository:     productsRepository,
            saleRepository:         saleRepository,
            productLocalDataSource: productLocalDataSource,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalesCubit, SalesState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == SalesStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sale Confirmed Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == SalesStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SalesCubit, SalesState>(
        builder: (context, state) {
          final cubit = context.read<SalesCubit>();
          final s     = AppSizes.s;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'Record Sale',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: s(context, 20),
                ),
              ),
              actions: [
                if (state.uiState == 2)
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textPrimary, size: s(context, 22)),
                    onPressed: cubit.reset,
                  ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.hPad(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Today's summary card ──
                  _buildSalesCard(context, state),

                  Padding(
                    padding: EdgeInsets.only(top: s(context, 24), bottom: s(context, 8)),
                    child: Text(
                      'Select Product',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: s(context, 13)),
                    ),
                  ),

                  _buildSearchField(context, state),

                  if (state.uiState == 1) _buildDropdownList(context, state, cubit),
                  if (state.uiState == 2) _buildProductDetailsCard(context, state, cubit),

                  const Spacer(),
                  _buildConfirmButton(context, state, cubit),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNav(context),
          );
        },
      ),
    );
  }

  Widget _buildSalesCard(BuildContext context, SalesState state) {
    final s = AppSizes.s;
    return Container(
      margin: EdgeInsets.only(top: s(context, 10)),
      padding: EdgeInsets.symmetric(horizontal: s(context, 16), vertical: s(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.cardBorder,
        borderRadius: BorderRadius.circular(s(context, 12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Sales",
                  style: TextStyle(fontSize: s(context, 13), color: AppColors.textSecondary)),
              SizedBox(height: s(context, 4)),
              Text('${state.todayTransactionsCount} Transactions',
                  style: TextStyle(fontSize: s(context, 15), fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total',
                  style: TextStyle(fontSize: s(context, 13), color: AppColors.textSecondary)),
              SizedBox(height: s(context, 4)),
              Text('${state.todayTotalAmount.toStringAsFixed(0)} EGP',
                  style: TextStyle(fontSize: s(context, 15), fontWeight: FontWeight.bold,
                      color: AppColors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, SalesState state) {
    final s = AppSizes.s;
    return TextField(
      onChanged: (v) => context.read<SalesCubit>().searchProduct(v),
      style: TextStyle(fontSize: s(context, 14)),
      decoration: InputDecoration(
        hintText: state.uiState == 2 ? state.selectedProduct?.name : 'Search..',
        hintStyle: TextStyle(
          color: state.uiState == 2 ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: state.uiState == 2 ? FontWeight.w500 : FontWeight.normal,
        ),
        prefixIcon: state.uiState == 2
            ? null
            : Icon(Icons.search, color: AppColors.textSecondary, size: s(context, 20)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: s(context, 14), horizontal: s(context, 12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 8)),
          borderSide: BorderSide(
            color: state.uiState == 0 ? AppColors.cardBorder : AppColors.textPrimary,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(s(context, 8)),
          borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownList(BuildContext context, SalesState state, SalesCubit cubit) {
    final s = AppSizes.s;
    return Container(
      margin: EdgeInsets.only(top: s(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(s(context, 8)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: state.searchResults.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final product = state.searchResults[index];
          return ListTile(
            title: Text(product.name,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: s(context, 14))),
            trailing: Text('In Stock: ${product.quantity}',
                style: TextStyle(color: AppColors.textSecondary, fontSize: s(context, 12))),
            onTap: () => cubit.selectProduct(product),
          );
        },
      ),
    );
  }

  Widget _buildProductDetailsCard(BuildContext context, SalesState state, SalesCubit cubit) {
    final s = AppSizes.s;
    return Container(
      margin: EdgeInsets.only(top: s(context, 16)),
      padding: EdgeInsets.all(s(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(s(context, 10)),
      ),
      child: Column(
        children: [
          _rowItem(context, 'Selling Price', '${state.selectedProduct?.sellPrice ?? 0} EGP'),
          SizedBox(height: s(context, 8)),
          _rowItem(context, 'In Stock', '${state.selectedProduct?.quantity ?? 0}'),
          SizedBox(height: s(context, 8)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Quantity',
                style: TextStyle(color: Colors.white, fontSize: s(context, 14))),
          ),
          SizedBox(height: s(context, 8)),
          Row(
            children: [
              GestureDetector(
                onTap: cubit.decrement,
                child: Icon(Icons.remove, color: Colors.white, size: s(context, 28)),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: s(context, 16)),
                  padding: EdgeInsets.symmetric(vertical: s(context, 6)),
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(s(context, 8)),
                  ),
                  alignment: Alignment.center,
                  child: Text('${state.quantity}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: s(context, 15))),
                ),
              ),
              GestureDetector(
                onTap: cubit.increment,
                child: Icon(Icons.add, color: Colors.white, size: s(context, 28)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: s(context, 14)),
            child: const Divider(color: Colors.white54, thickness: 1, height: 1),
          ),
          _rowItem(context, 'Total :', '${state.total.toStringAsFixed(0)} EGP'),
        ],
      ),
    );
  }

  Widget _rowItem(BuildContext context, String label, String value) {
    final s = AppSizes.s;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: s(context, 14))),
        Text(value,  style: TextStyle(color: Colors.white, fontSize: s(context, 14))),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context, SalesState state, SalesCubit cubit) {
    final s        = AppSizes.s;
    final isActive = state.uiState == 2 && state.status != SalesStatus.loading;

    return Container(
      margin: EdgeInsets.only(bottom: s(context, 24)),
      width: double.infinity,
      height: s(context, 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? AppColors.orange : AppColors.orange.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(s(context, 10))),
          elevation: 0,
        ),
        onPressed: isActive ? cubit.confirmSale : null,
        child: state.status == SalesStatus.loading
            ? SizedBox(
                height: s(context, 20),
                width: s(context, 20),
                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text('Confirm Sale',
                style: TextStyle(
                  fontSize: s(context, 16),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final s     = AppSizes.s;
    final items = [
      [_AppIcons.home,     'Home'],
      [_AppIcons.product,  'Products'],
      [_AppIcons.sales,    'Sales'],
      [_AppIcons.expenses, 'Expenses'],
      [_AppIcons.chart,    'Reports'],
    ];

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(s(context,12), s(context,8), s(context,12), s(context,16)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: s(context,16), vertical: s(context,10)),
        decoration: BoxDecoration(
          color: AppColors.navCardBg,
          borderRadius: BorderRadius.circular(s(context, 20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == _activeIndex;
            final color    = isActive ? AppColors.orange : AppColors.textSecondary;
            return GestureDetector(
              onTap: () => _navigateTo(context, i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(items[i][0], width: s(context,24), height: s(context,24), color: color),
                    if (isActive) ...[
                      SizedBox(height: s(context, 2)),
                      Text(items[i][1],
                          style: TextStyle(fontSize: s(context,11), color: color)),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}