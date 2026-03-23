import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:ribhi/features/Dashboard/presentation/cubit/dashboard_state.dart';
import 'package:ribhi/features/Dashboard/presentation/ui/widgets/net_profit_card.dart';
import 'package:ribhi/features/Dashboard/presentation/ui/widgets/stat_card.dart';
import 'package:ribhi/features/Dashboard/presentation/ui/widgets/weekly_profit_chart.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:ribhi/features/Expenses/presentation/ui/screens/ExpensesScreen.dart';
import 'package:ribhi/features/Initialization/data/datasource/SettingLocalData.dart';
import 'package:ribhi/features/auth/data/datasource/auth_local_service.dart';
import 'package:ribhi/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/presentation/UI/screens/ProductsScreen.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_cubit.dart';
import 'package:ribhi/features/reports/presentation/ui/screens/ReportsScreen.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';
import 'package:ribhi/features/sales/presentation/UI.dart';


class _AppIcons {
  static const home     = 'assets/photo/iconamoon_category-light.png';
  static const product  = 'assets/photo/fluent-mdl2_product.png';
  static const sales    = 'assets/photo/Frame 197 (1).png';
  static const expenses = 'assets/photo/iconoir_wallet.png';
  static const chart    = 'assets/photo/carbon_analytics.png';
  static const warning  = 'assets/photo/emojione-v1_warning.png';
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

class DashboardScreen extends StatefulWidget {
  final ExpenseRepository          expensesRepository;
  final ReportsRepositoryImpl      reportsRepository;
  final ProductRepositoryImpl      productsRepository;
  final SaleRepositoryImpl         saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;
  final SettingsLocalDataSource?   settingsDataSource;

  const DashboardScreen({
    super.key,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
    this.settingsDataSource,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadStats();
  }

  Future<void> _logout() async {
    await AuthLocalService().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SignInScreen(
          storeName:        '',
          startingCapital:  0,
          selectedCurrency: 'EGP',
          expensesRepository:     widget.expensesRepository,
          reportsRepository:      widget.reportsRepository,
          productsRepository:     widget.productsRepository,
          saleRepository:         widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) return const Center(child: CircularProgressIndicator(color: AppColors.green));
            if (state is DashboardError)   return Center(child: Text(state.message, style: const TextStyle(color: AppColors.red)));
            if (state is DashboardLoaded)  return _buildContent(state);
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _logout,
        backgroundColor: const Color(0xFFFF4D00),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        heroTag: 'logout_fab',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildContent(DashboardLoaded state) {
    final stats = state.stats;
    final s     = AppSizes.s;
    final hp    = AppSizes.hPad(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: s(context, 22)),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: s(context, 18), fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                children: const [
                  TextSpan(text: 'Track, Manage, Profit with '),
                  TextSpan(text: 'Ribhi', style: TextStyle(color: AppColors.orange)),
                ],
              ),
            ),
            SizedBox(height: s(context, 4)),
            Text("Let's get your smart store set up",
                style: TextStyle(fontSize: s(context, 13), color: AppColors.textSecondary)),
            SizedBox(height: s(context, 18)),
            NetProfitCard(amount: stats.netProfit),
            SizedBox(height: s(context, 26)),
            Padding(
              padding: EdgeInsets.only(left: s(context, 10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: StatCard(imagePath: _AppIcons.product, label: 'Inventory Value',   value: '${_fmt(stats.inventoryValue)} EGP', valueColor: AppColors.blue)),
                  SizedBox(width: s(context, 12)),
                  Expanded(child: StatCard(imagePath: _AppIcons.sales,    label: "Today's Sales",    value: '${_fmt(stats.todaySales)} EGP',     valueColor: AppColors.green)),
                ],
              ),
            ),
            SizedBox(height: s(context, 26)),
            Padding(
              padding: EdgeInsets.only(left: s(context, 10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: StatCard(imagePath: _AppIcons.expenses, label: "Today's Expenses", value: '${_fmt(stats.todayExpenses)} EGP',  valueColor: AppColors.red)),
                  SizedBox(width: s(context, 12)),
                  Expanded(child: StatCard(imagePath: _AppIcons.warning,  label: 'Low Stock Items',  value: '${stats.lowStockItems} Products',   valueColor: AppColors.yellow)),
                ],
              ),
            ),
            SizedBox(height: s(context, 28)),
            WeeklyProfitChart(profits: stats.weeklyProfits),
            SizedBox(height: s(context, 24)),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) => v.toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  void _navigateTo(int i) {
    if (i == 1) {
      Navigator.push(context, _NavRoute(
        page: ProductsScreen(
          expensesRepository:     widget.expensesRepository,
          reportsRepository:      widget.reportsRepository,
          productsRepository:     widget.productsRepository,
          saleRepository:         widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
        ),
      )).then((_) { if (mounted) context.read<DashboardCubit>().loadStats(); });
    } else if (i == 2) {
      Navigator.push(context, _NavRoute(
        page: SalesScreen(
          saleRepository:         widget.saleRepository,
          productLocalDataSource: widget.productLocalDataSource,
          expensesRepository:     widget.expensesRepository,
          reportsRepository:      widget.reportsRepository,
          productsRepository:     widget.productsRepository,
        ),
      )).then((_) { if (mounted) context.read<DashboardCubit>().loadStats(); });
    } else if (i == 3) {
      Navigator.push(context, _NavRoute(
        page: BlocProvider(
          create: (_) => ExpensesCubit(repository: widget.expensesRepository)..loadExpenses(),
          child: ExpensesScreen(
            expensesRepository:     widget.expensesRepository,
            reportsRepository:      widget.reportsRepository,
            productsRepository:     widget.productsRepository,
            saleRepository:         widget.saleRepository,
            productLocalDataSource: widget.productLocalDataSource,
          ),
        ),
      )).then((_) { if (mounted) context.read<DashboardCubit>().loadStats(); });
    } else if (i == 4) {
      Navigator.push(context, _NavRoute(
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
    } else {
      setState(() => _selectedNavIndex = i);
    }
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
        decoration: BoxDecoration(
          color: AppColors.navCardBg,
          borderRadius: BorderRadius.circular(s(context, 20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == _selectedNavIndex;
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