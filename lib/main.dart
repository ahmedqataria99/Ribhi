import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/database/DatabaseHelper.dart';
import 'package:ribhi/core/theme/app_theme.dart';
import 'package:ribhi/features/Dashboard/data/datasource/DashboardDataSource.dart';
import 'package:ribhi/features/Dashboard/data/repo/DashboardRepoImpl.dart';
import 'package:ribhi/features/Dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:ribhi/features/Dashboard/presentation/ui/screens/DashboardScreen.dart';
import 'package:ribhi/features/Expenses/data/datasource/ExpensesDataStore.dart';
import 'package:ribhi/features/Expenses/data/repo/ExpensesRepoImpl.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/reports/data/datasource/RebortDataStore.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/sales/data/datastore/saleDataSource.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
       defaultTargetPlatform == TargetPlatform.linux   ||
       defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final db = DatabaseHelper.instance;

  final dashboardDataSource = DashboardLocalDataSourceImpl(db);
  final dashboardRepository = DashboardRepositoryImpl(dashboardDataSource);

  final expensesDataSource  = ExpenseLocalDataSourceImpl(db);
  final expensesRepository  = ExpenseRepositoryImpl(expensesDataSource);

  final reportsDataSource   = ReportsLocalDataSourceImpl(db);
  final reportsRepository   = ReportsRepositoryImpl(reportsDataSource);

  final productsDataSource  = ProductLocalDataSourceImpl(db);
  final productsRepository  = ProductRepositoryImpl(productsDataSource);

  final saleDataSource      = SaleLocalDataSourceImpl(db);
  final saleRepository      = SaleRepositoryImpl(
    db:           db,
    saleLocal:    saleDataSource,
    productLocal: productsDataSource,
  );

  runApp(MyApp(
    dashboardRepository:    dashboardRepository,
    expensesRepository:     expensesRepository,
    reportsRepository:      reportsRepository,
    productsRepository:     productsRepository,
    saleRepository:         saleRepository,
    productLocalDataSource: productsDataSource,
  ));
}

class MyApp extends StatelessWidget {
  final DashboardRepositoryImpl    dashboardRepository;
  final ExpenseRepositoryImpl      expensesRepository;
  final ReportsRepositoryImpl      reportsRepository;
  final ProductRepositoryImpl      productsRepository;
  final SaleRepositoryImpl         saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const MyApp({
    super.key,
    required this.dashboardRepository,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProductRepository>.value(
      value: productsRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => DashboardCubit(repository: dashboardRepository)..loadStats(),
          ),
          BlocProvider(
            create: (_) => ProductsCubit(productsRepository)..loadProducts(),
          ),
        ],
        child: MaterialApp(
          title: 'Ribhi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: DashboardScreen(
            expensesRepository:     expensesRepository,
            reportsRepository:      reportsRepository,
            productsRepository:     productsRepository,
            saleRepository:         saleRepository,
            productLocalDataSource: productLocalDataSource,
          ),
        ),
      ),
    );
  }
}