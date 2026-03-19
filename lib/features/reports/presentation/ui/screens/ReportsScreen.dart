import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:ribhi/features/Expenses/presentation/ui/screens/ExpensesScreen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/presentation/UI/screens/ProductsScreen.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/reports/domain/entity/reports.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_cubit.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_state.dart';
import 'package:ribhi/features/reports/presentation/ui/widgets/low_stock_item.dart';
import 'package:ribhi/features/reports/presentation/ui/widgets/report_bar_chart.dart';
import 'package:ribhi/features/reports/presentation/ui/widgets/report_green_card.dart';
import 'package:ribhi/features/reports/presentation/ui/widgets/report_mini_stat_card.dart';
import 'package:ribhi/features/reports/presentation/ui/widgets/report_stat_row.dart';
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

enum _ReportTab { daily, monthly, inventory }

class ReportsScreen extends StatefulWidget {
  final ReportsRepositoryImpl      reportsRepository;
  final ExpenseRepository          expensesRepository;
  final ProductRepositoryImpl      productsRepository;
  final SaleRepositoryImpl         saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const ReportsScreen({
    super.key,
    required this.reportsRepository,
    required this.expensesRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const int _activeIndex = 4;
  _ReportTab _tab = _ReportTab.daily;

  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().loadDaily();
  }

  void _switchTab(_ReportTab tab) {
    if (_tab == tab) return;
    setState(() => _tab = tab);
    final cubit = context.read<ReportsCubit>();
    switch (tab) {
      case _ReportTab.daily:     cubit.loadDaily();     break;
      case _ReportTab.monthly:   cubit.loadMonthly();   break;
      case _ReportTab.inventory: cubit.loadInventory(); break;
    }
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
    } else if (i == 3) {
      Navigator.pushReplacement(context, _NavRoute(
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
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: s(context, 16)),
            _ReportsTabBar(currentTab: _tab, onTab: _switchTab),
            SizedBox(height: s(context, 16)),
            Expanded(
              child: BlocBuilder<ReportsCubit, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoading)        return const Center(child: CircularProgressIndicator(color: AppColors.green));
                  if (state is ReportsError)          return Center(child: Text(state.message, style: const TextStyle(color: AppColors.red)));
                  if (state is DailyReportLoaded)     return _DailyTab(report: state.report);
                  if (state is MonthlyReportLoaded)   return _MonthlyTab(report: state.report);
                  if (state is InventoryReportLoaded) return _InventoryTab(report: state.report);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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
                      Text(items[i][1] , style: TextStyle(fontSize: s(context,11), color: color)),
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

// ── Tab Bar ────────────────────────────────────────────────────────
class _ReportsTabBar extends StatelessWidget {
  final _ReportTab currentTab;
  final void Function(_ReportTab) onTab;
  const _ReportsTabBar({required this.currentTab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    final tabs = [(_ReportTab.daily,'Daily'), (_ReportTab.monthly,'Monthly'), (_ReportTab.inventory,'Inventory')];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.hPad(context)),
      child: Container(
        padding: EdgeInsets.all(s(context, 4)),
        decoration: BoxDecoration(color: AppColors.navCardBg, borderRadius: BorderRadius.circular(s(context, 14))),
        child: Row(
          children: tabs.map((t) {
            final isActive = currentTab == t.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTab(t.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: s(context, 8)),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(s(context, 20)),
                  ),
                  child: Text(t.$2, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: s(context, 13),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          color: isActive ? AppColors.orange : AppColors.textSecondary)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Daily Tab ──────────────────────────────────────────────────────
class _DailyTab extends StatelessWidget {
  final DailyReport report;
  const _DailyTab({required this.report});
  String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s; final hp = AppSizes.hPad(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: hp),
      child: Column(children: [
        ReportGreenCard(title: 'Net Profit', value: '${_fmt(report.grossProfit)} EGP', icon: 'assets/photo/carbon_analytics.png'),
        SizedBox(height: s(context, 20)),
        ReportStatRow(label: 'Total sales',           value: '${_fmt(report.totalSales)} EGP',    valueColor: AppColors.green),
        ReportStatRow(label: 'Total Expenses',         value: '${_fmt(report.totalExpenses)} EGP', valueColor: AppColors.red),
        ReportStatRow(label: 'Gross profit',           value: '${_fmt(report.grossProfit)} EGP',   valueColor: AppColors.orange),
        ReportStatRow(label: 'Number of transactions', value: '${report.numberOfTransactions}',    valueColor: AppColors.blue),
        SizedBox(height: s(context, 24)),
      ]),
    );
  }
}

// ── Monthly Tab ────────────────────────────────────────────────────
class _MonthlyTab extends StatelessWidget {
  final MonthlyReport report;
  const _MonthlyTab({required this.report});
  String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s; final hp = AppSizes.hPad(context);
    return LayoutBuilder(builder: (context, constraints) {
      final availH  = constraints.maxHeight;
      final chartH  = s(context, 240) + s(context, 46);
      final statsH  = s(context, 56);
      final freeH   = availH - chartH - statsH;
      final topPad  = (freeH / 2).clamp(s(context, 20), availH * 0.18);

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: hp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: topPad),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: ReportMiniStatCard(label: 'Total Revenue', value: '${_fmt(report.totalRevenue)} EGP', valueColor: AppColors.blue)),
            SizedBox(width: s(context, 12)),
            Expanded(child: ReportMiniStatCard(label: 'Total Profit',  value: '${_fmt(report.totalProfit)} EGP',  valueColor: AppColors.green)),
          ]),
          SizedBox(height: topPad * 0.8),
          ReportBarChart(title: 'Daily profits', profits: report.dailyProfits),
          SizedBox(height: s(context, 24)),
        ]),
      );
    });
  }
}

// ── Inventory Tab ──────────────────────────────────────────────────
class _InventoryTab extends StatelessWidget {
  final InventoryReport report;
  const _InventoryTab({required this.report});
  String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s; final hp = AppSizes.hPad(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: hp),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ReportGreenCard(title: 'Total inventory value', value: '${_fmt(report.totalInventoryValue)} EGP', icon: 'assets/photo/fluent-mdl2_product.png'),
        SizedBox(height: s(context, 24)),
        Text('Needs restocking (${report.lowStockProducts.length})',
            style: TextStyle(fontSize: s(context,16), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: s(context, 12)),
        if (report.lowStockProducts.isEmpty)
          Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: s(context, 24)),
            child: Text('All products are well stocked',
                style: TextStyle(fontSize: s(context,14), color: AppColors.textSecondary)),
          ))
        else
          ...report.lowStockProducts.map((p) => LowStockItem(product: p)),
        SizedBox(height: s(context, 24)),
      ]),
    );
  }
}