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

// Subscription and Backup imports
import 'package:ribhi/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_state.dart';
import 'package:ribhi/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:ribhi/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:ribhi/features/backup/presentation/cubit/backup_state.dart';
import 'package:ribhi/core/security/admin_guard.dart';

// Premium popup
import 'package:ribhi/features/subscription/presentation/widgets/premium_popup.dart';

class _AppIcons {
  static const home = 'assets/photo/iconamoon_category-light.png';
  static const product = 'assets/photo/fluent-mdl2_product.png';
  static const sales = 'assets/photo/Frame 197 (1).png';
  static const expenses = 'assets/photo/iconoir_wallet.png';
  static const chart = 'assets/photo/carbon_analytics.png';
  static const warning = 'assets/photo/emojione-v1_warning.png';
}

class _NavRoute extends PageRouteBuilder {
  _NavRoute({required Widget page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, anim, secondaryAnim, child) {
          final curved = CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 280),
      );
}

class DashboardScreen extends StatefulWidget {
  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;
  final SettingsLocalDataSource? settingsDataSource;

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
  bool _expiryWarningShown = false;
  late final Future<bool> _adminAccessFuture;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadStats();
    _adminAccessFuture = AdminGuard.canAccessAdmin();
  }

  Future<void> _logout() async {
    await AuthLocalService().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SignInScreen(
          storeName: '',
          startingCapital: 0,
          selectedCurrency: 'EGP',
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
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionLoaded &&
            state.isPremium &&
            state.expiryDate != null) {
          final daysLeft = state.expiryDate!.difference(DateTime.now()).inDays;
          if (daysLeft >= 0 && daysLeft <= 7 && !_expiryWarningShown) {
            _expiryWarningShown = true;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Subscription Expiring Soon'),
                content: Text(
                  'Your premium subscription expires in $daysLeft day${daysLeft == 1 ? '' : 's'}. Please renew to keep cloud backup active.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Later'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _navigateToSubscription(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                    ),
                    child: const Text('Renew Now'),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text(
            'Dashboard',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    );
                  }
                  if (state is DashboardError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.red),
                      ),
                    );
                  }
                  if (state is DashboardLoaded) return _buildContent(state);
                  return const SizedBox.shrink();
                },
              ),
              const PremiumPopup(),
            ],
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
      ),
    );
  }

  Widget _buildContent(DashboardLoaded state) {
    final stats = state.stats;
    final s = AppSizes.s;
    final hp = AppSizes.hPad(context);

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
                style: TextStyle(
                  fontSize: s(context, 18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                children: const [
                  TextSpan(text: 'Track, Manage, Profit with '),
                  TextSpan(
                    text: 'Ribhi',
                    style: TextStyle(color: AppColors.orange),
                  ),
                ],
              ),
            ),
            SizedBox(height: s(context, 4)),
            Text(
              "Let's get your smart store set up",
              style: TextStyle(
                fontSize: s(context, 13),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: s(context, 18)),
            NetProfitCard(amount: stats.netProfit),
            SizedBox(height: s(context, 26)),
            Padding(
              padding: EdgeInsets.only(left: s(context, 10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StatCard(
                      imagePath: _AppIcons.product,
                      label: 'Inventory Value',
                      value: '${_fmt(stats.inventoryValue)} EGP',
                      valueColor: AppColors.blue,
                    ),
                  ),
                  SizedBox(width: s(context, 12)),
                  Expanded(
                    child: StatCard(
                      imagePath: _AppIcons.sales,
                      label: "Today's Sales",
                      value: '${_fmt(stats.todaySales)} EGP',
                      valueColor: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: s(context, 26)),
            Padding(
              padding: EdgeInsets.only(left: s(context, 10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StatCard(
                      imagePath: _AppIcons.expenses,
                      label: "Today's Expenses",
                      value: '${_fmt(stats.todayExpenses)} EGP',
                      valueColor: AppColors.red,
                    ),
                  ),
                  SizedBox(width: s(context, 12)),
                  Expanded(
                    child: StatCard(
                      imagePath: _AppIcons.warning,
                      label: 'Low Stock Items',
                      value: '${stats.lowStockItems} Products',
                      valueColor: AppColors.yellow,
                    ),
                  ),
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

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  void _navigateTo(int i) {
    if (i == 1) {
      Navigator.push(
        context,
        _NavRoute(
          page: ProductsScreen(
            expensesRepository: widget.expensesRepository,
            reportsRepository: widget.reportsRepository,
            productsRepository: widget.productsRepository,
            saleRepository: widget.saleRepository,
            productLocalDataSource: widget.productLocalDataSource,
          ),
        ),
      ).then((_) {
        if (mounted) context.read<DashboardCubit>().loadStats();
      });
    } else if (i == 2) {
      Navigator.push(
        context,
        _NavRoute(
          page: SalesScreen(
            saleRepository: widget.saleRepository,
            productLocalDataSource: widget.productLocalDataSource,
            expensesRepository: widget.expensesRepository,
            reportsRepository: widget.reportsRepository,
            productsRepository: widget.productsRepository,
          ),
        ),
      ).then((_) {
        if (mounted) context.read<DashboardCubit>().loadStats();
      });
    } else if (i == 3) {
      Navigator.push(
        context,
        _NavRoute(
          page: BlocProvider(
            create: (_) =>
                ExpensesCubit(repository: widget.expensesRepository)
                  ..loadExpenses(),
            child: ExpensesScreen(
              expensesRepository: widget.expensesRepository,
              reportsRepository: widget.reportsRepository,
              productsRepository: widget.productsRepository,
              saleRepository: widget.saleRepository,
              productLocalDataSource: widget.productLocalDataSource,
            ),
          ),
        ),
      ).then((_) {
        if (mounted) context.read<DashboardCubit>().loadStats();
      });
    } else if (i == 4) {
      Navigator.push(
        context,
        _NavRoute(
          page: BlocProvider(
            create: (_) => ReportsCubit(repository: widget.reportsRepository),
            child: ReportsScreen(
              reportsRepository: widget.reportsRepository,
              expensesRepository: widget.expensesRepository,
              productsRepository: widget.productsRepository,
              saleRepository: widget.saleRepository,
              productLocalDataSource: widget.productLocalDataSource,
            ),
          ),
        ),
      );
    } else {
      setState(() => _selectedNavIndex = i);
    }
  }

  Widget _buildBottomNav() {
    final s = AppSizes.s;
    final items = [
      [_AppIcons.home, 'Home'],
      [_AppIcons.product, 'Products'],
      [_AppIcons.sales, 'Sales'],
      [_AppIcons.expenses, 'Expenses'],
      [_AppIcons.chart, 'Reports'],
    ];

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        s(context, 12),
        s(context, 8),
        s(context, 12),
        s(context, 16),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: s(context, 16),
          vertical: s(context, 10),
        ),
        decoration: BoxDecoration(
          color: AppColors.navCardBg,
          borderRadius: BorderRadius.circular(s(context, 20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == _selectedNavIndex;
            final color = isActive ? AppColors.orange : AppColors.textSecondary;
            return GestureDetector(
              onTap: () => _navigateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      items[i][0],
                      width: s(context, 24),
                      height: s(context, 24),
                      color: color,
                    ),
                    if (isActive) ...[
                      SizedBox(height: s(context, 2)),
                      Text(
                        items[i][1],
                        style: TextStyle(
                          fontSize: s(context, 11),
                          color: color,
                        ),
                      ),
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

  Widget _buildDrawer(BuildContext context) {
    final s = AppSizes.s;

    return Drawer(
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + s(context, 20),
                bottom: s(context, 20),
                left: s(context, 16),
                right: s(context, 16),
              ),
              decoration: const BoxDecoration(color: AppColors.orange),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ribhi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Business Management',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Cloud Backup Section
                  Container(
                    margin: EdgeInsets.all(s(context, 16)),
                    padding: EdgeInsets.all(s(context, 16)),
                    decoration: BoxDecoration(
                      color: AppColors.navCardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cloud,
                              color: AppColors.orange,
                              size: s(context, 24),
                            ),
                            SizedBox(width: s(context, 12)),
                            Text(
                              'Cloud Backup',
                              style: TextStyle(
                                fontSize: s(context, 18),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: s(context, 16)),

                        // Backup Now with loading state
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          builder: (context, subState) {
                            final isPremium = subState is SubscriptionLoaded
                                ? subState.isPremium
                                : false;

                            return BlocBuilder<BackupCubit, BackupState>(
                              builder: (context, backupState) {
                                final isLoading = backupState is BackupLoading;

                                return ListTile(
                                  leading: isLoading
                                      ? SizedBox(
                                          width: s(context, 24),
                                          height: s(context, 24),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: isPremium
                                                ? AppColors.green
                                                : Colors.grey,
                                          ),
                                        )
                                      : Icon(
                                          Icons.backup,
                                          color: isPremium
                                              ? AppColors.green
                                              : Colors.grey,
                                        ),
                                  title: Text(
                                    isLoading ? 'Backing up...' : 'Backup Now',
                                  ),
                                  subtitle: isPremium
                                      ? null
                                      : const Text('Premium required'),
                                  onTap: isPremium && !isLoading
                                      ? () => _handleBackup(context)
                                      : () => _showPremiumRequired(context),
                                  enabled: isPremium && !isLoading,
                                );
                              },
                            );
                          },
                        ),

                        // Restore Backup with loading state
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          builder: (context, subState) {
                            final isPremium = subState is SubscriptionLoaded
                                ? subState.isPremium
                                : false;

                            return BlocBuilder<BackupCubit, BackupState>(
                              builder: (context, backupState) {
                                final isLoading = backupState is BackupLoading;

                                return ListTile(
                                  leading: isLoading
                                      ? SizedBox(
                                          width: s(context, 24),
                                          height: s(context, 24),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: isPremium
                                                ? AppColors.green
                                                : Colors.grey,
                                          ),
                                        )
                                      : Icon(
                                          Icons.restore,
                                          color: isPremium
                                              ? AppColors.green
                                              : Colors.grey,
                                        ),
                                  title: Text(
                                    isLoading
                                        ? 'Restoring...'
                                        : 'Restore Backup',
                                  ),
                                  subtitle: isPremium
                                      ? null
                                      : const Text('Premium required'),
                                  onTap: isPremium && !isLoading
                                      ? () => _handleRestore(context)
                                      : () => _showPremiumRequired(context),
                                  enabled: isPremium && !isLoading,
                                );
                              },
                            );
                          },
                        ),

                        // Last Backup Time with enhanced status
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          builder: (context, subState) {
                            final isPremium = subState is SubscriptionLoaded
                                ? subState.isPremium
                                : false;
                            final lastBackup = subState is SubscriptionLoaded
                                ? subState.lastBackup
                                : null;
                            final plan = subState is SubscriptionLoaded
                                ? subState.plan
                                : null;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Premium Status Badge
                                if (isPremium)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: s(context, 8),
                                      vertical: s(context, 4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.green.withValues(
                                        alpha: 0.1,
                                        red: AppColors.green.r,
                                        green: AppColors.green.g,
                                        blue: AppColors.green.b,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.green,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: AppColors.green,
                                          size: s(context, 16),
                                        ),
                                        SizedBox(width: s(context, 4)),
                                        Text(
                                          plan ?? 'Premium',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: s(context, 12),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                SizedBox(height: s(context, 12)),

                                // Backup Status
                                Row(
                                  children: [
                                    Icon(
                                      lastBackup != null
                                          ? Icons.cloud_done
                                          : Icons.cloud_off,
                                      color: lastBackup != null
                                          ? AppColors.green
                                          : Colors.grey,
                                      size: s(context, 20),
                                    ),
                                    SizedBox(width: s(context, 8)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lastBackup != null
                                                ? 'Last Backup: ${lastBackup.day}/${lastBackup.month}/${lastBackup.year}'
                                                : 'No backup yet',
                                            style: TextStyle(
                                              fontSize: s(context, 12),
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            isPremium
                                                ? 'Cloud sync enabled'
                                                : 'Cloud sync disabled',
                                            style: TextStyle(
                                              fontSize: s(context, 10),
                                              color: isPremium
                                                  ? AppColors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Auto Backup Status
                                if (isPremium)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: s(context, 8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.autorenew,
                                          color: AppColors.orange,
                                          size: s(context, 16),
                                        ),
                                        SizedBox(width: s(context, 6)),
                                        Text(
                                          'Auto backup enabled',
                                          style: TextStyle(
                                            fontSize: s(context, 12),
                                            color: AppColors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                        // Upgrade to Premium
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          builder: (context, subState) {
                            final isPremium = subState is SubscriptionLoaded
                                ? subState.isPremium
                                : false;
                            if (isPremium) return const SizedBox.shrink();

                            return Container(
                              margin: EdgeInsets.only(top: s(context, 12)),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _navigateToSubscription(context),
                                icon: const Icon(Icons.star),
                                label: const Text('Upgrade to Premium'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  FutureBuilder<bool>(
                    future: _adminAccessFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done ||
                          snapshot.data != true) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        leading: const Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.orange,
                        ),
                        title: const Text('Admin Panel'),
                        subtitle: const Text('Manage premium and backups'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/admin');
                        },
                      );
                    },
                  ),

                  // Other menu items can be added here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackup(BuildContext context) async {
    final backupCubit = context.read<BackupCubit>();
    final hasInternet = await backupCubit.checkInternetConnection();

    if (!hasInternet) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
      return;
    }

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocConsumer<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state is BackupSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup completed successfully!')),
            );
            context.read<SubscriptionCubit>().loadSubscriptionStatus();
          } else if (state is BackupError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Backup failed: ${state.message}')),
            );
          } else if (state is BackupQueued) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final progress = state is BackupInProgress ? state.progress : null;
          return AlertDialog(
            title: const Text('Backing up...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (progress != null)
                  LinearProgressIndicator(value: progress)
                else
                  const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  state is BackupInProgress
                      ? 'Uploading to cloud... ${(state.progress * 100).toStringAsFixed(0)}%'
                      : 'Preparing backup...',
                ),
              ],
            ),
          );
        },
      ),
    );

    backupCubit.uploadBackup();
  }

  void _handleRestore(BuildContext context) async {
    final backupCubit = context.read<BackupCubit>();
    final hasInternet = await backupCubit.checkInternetConnection();

    if (!hasInternet) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
      return;
    }

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocConsumer<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state is RestoreSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup restored successfully!')),
            );
            // Reload app data
            context.read<DashboardCubit>().loadStats();
          } else if (state is BackupError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Restore failed: ${state.message}')),
            );
          } else if (state is BackupQueued) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final progress = state is RestoreInProgress ? state.progress : null;
          return AlertDialog(
            title: const Text('Restoring...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (progress != null)
                  LinearProgressIndicator(value: progress)
                else
                  const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  state is RestoreInProgress
                      ? 'Downloading from cloud... ${(state.progress * 100).toStringAsFixed(0)}%'
                      : 'Preparing restore...',
                ),
              ],
            ),
          );
        },
      ),
    );

    backupCubit.restoreBackup();
  }

  void _showPremiumRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Required'),
        content: const Text(
          'This feature requires a premium subscription. Upgrade now to access cloud backup features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToSubscription(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _navigateToSubscription(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SubscriptionCubit>(),
          child: const SubscriptionScreen(),
        ),
      ),
    );
  }
}
