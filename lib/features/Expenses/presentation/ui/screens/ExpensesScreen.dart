import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_state.dart';
import 'package:ribhi/features/Expenses/presentation/ui/widgets/add_expense_sheet.dart';
import 'package:ribhi/features/Expenses/presentation/ui/widgets/category_chips_widget.dart';
import 'package:ribhi/features/Expenses/presentation/ui/widgets/expense_distribution_widget.dart';
import 'package:ribhi/features/Expenses/presentation/ui/widgets/expense_item_widget.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/presentation/UI/screens/ProductsScreen.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_cubit.dart';
import 'package:ribhi/features/reports/presentation/ui/screens/ReportsScreen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';
import 'package:ribhi/features/sales/presentation/UI.dart';


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
            final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
            return SlideTransition(
              position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
              child: FadeTransition(opacity: curved, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 280),
        );
}

class ExpensesScreen extends StatefulWidget {
  final ExpenseRepository     expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl      productsRepository;
  final SaleRepositoryImpl         saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const ExpensesScreen({
    super.key,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  static const int _activeIndex = 3;

  @override
  void initState() {
    super.initState();
    context.read<ExpensesCubit>().loadExpenses();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ExpensesCubit>(),
        child: const AddExpenseSheet(),
      ),
    );
  }

  void _navigateTo(int i) {
    if (i == _activeIndex) return;
    if (i == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (i == 1) {
      Navigator.pushReplacement(context, _NavRoute(
        page: ProductsScreen(
          expensesRepository:     widget.expensesRepository,
          reportsRepository:      widget.reportsRepository,
          productsRepository:     widget.productsRepository,
          saleRepository:         widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
        ),
      ));
    } else if (i == 2) {
      Navigator.pushReplacement(context, _NavRoute(
        page: SalesScreen(
          saleRepository:         widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
          expensesRepository:     widget.expensesRepository,
          reportsRepository:      widget.reportsRepository,
          productsRepository:     widget.productsRepository,
        ),
      ));
    } else if (i == 4) {
      Navigator.pushReplacement(context, _NavRoute(
        page: BlocProvider(
          create: (_) => ReportsCubit(repository: widget.reportsRepository),
          child: ReportsScreen(
            reportsRepository:      widget.reportsRepository,
            expensesRepository:     widget.expensesRepository,
            productsRepository:     widget.productsRepository,
            saleRepository:         widget.saleRepository,
            productLocalDataSource: widget.productLocalDataSource,
          ),
        ),
      ));
    }
  }

  String _currentMonthLabel() {
    final now = DateTime.now();
    const months = ['January','February','March','April','May','June',
                    'July','August','September','October','November','December'];
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ExpensesCubit, ExpensesState>(
          builder: (context, state) {
            if (state is ExpensesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.green));
            if (state is ExpensesError)   return Center(child: Text(state.message));
            if (state is ExpensesLoaded)  return _buildContent(context, state);
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: AppColors.background, size: s(context, 28)),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildContent(BuildContext context, ExpensesLoaded state) {
    final s  = AppSizes.s;
    final hp = AppSizes.hPad(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: hp, vertical: s(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(s(context, 16)),
            decoration: BoxDecoration(color: AppColors.pinkLight, borderRadius: BorderRadius.circular(s(context, 14))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monthly fees', style: TextStyle(fontSize: s(context, 13), color: AppColors.textPrimary)),
                    SizedBox(height: s(context, 4)),
                    Text('${state.totalAmount.toInt()} EGP',
                        style: TextStyle(fontSize: s(context, 22), fontWeight: FontWeight.bold, color: AppColors.red)),
                    Text(_currentMonthLabel(),
                        style: TextStyle(fontSize: s(context, 13), color: AppColors.textPrimary)),
                  ],
                ),
                Image.asset('assets/photo/analystic.png', width: s(context,28), height: s(context,28), color: AppColors.red),
              ],
            ),
          ),
          SizedBox(height: s(context, 20)),
          if (state.distributionByCategory.isNotEmpty) ...[
            ExpenseDistributionWidget(distribution: state.distributionByCategory, total: state.totalAmount),
            SizedBox(height: s(context, 20)),
          ],
          CategoryChipsWidget(
            selectedCategory: state.selectedCategory,
            onCategoryTap: (cat) => context.read<ExpensesCubit>().filterByCategory(cat),
          ),
          SizedBox(height: s(context, 20)),
          Text('Expense list',
              style: TextStyle(fontSize: s(context,16), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          SizedBox(height: s(context, 10)),
          if (state.filteredExpenses.isEmpty)
            Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: s(context, 32)),
              child: Text('No expenses found',
                  style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: s(context, 14))),
            ))
          else
            ...state.filteredExpenses.map((e) => ExpenseItemWidget(expense: e)),
          SizedBox(height: s(context, 80)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
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
        decoration: BoxDecoration(color: AppColors.navCardBg, borderRadius: BorderRadius.circular(s(context, 20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == _activeIndex;
            final color    = isActive ? AppColors.orange : AppColors.textSecondary;
            return GestureDetector(
              onTap: () => _navigateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(items[i][0], width: s(context,24), height: s(context,24), color: color),
                    if (isActive) ...[
                      SizedBox(height: s(context, 2)),
                      Text(items[i][1], style: TextStyle(fontSize: s(context,11), color: color)),
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