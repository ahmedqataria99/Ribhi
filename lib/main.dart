import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 مهم
import 'package:ribhi/features/auth/data/datasource/FirebaseauthSerivce.dart';
import 'firebase_options.dart'; // 👈 مهم

import 'package:ribhi/core/database/DatabaseHelper.dart';
import 'package:ribhi/core/theme/app_theme.dart';

import 'package:ribhi/features/auth/data/datasource/auth_local_service.dart';
import 'package:ribhi/features/auth/data/repositories/auth_repository_impl.dart'; 
import 'package:ribhi/features/auth/presentation/manager/cubit/authCubit.dart';

import 'package:ribhi/features/Dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';

import 'package:ribhi/features/Dashboard/data/datasource/DashboardDataSource.dart';
import 'package:ribhi/features/Dashboard/data/repo/DashboardRepoImpl.dart';

import 'package:ribhi/features/Expenses/data/datasource/ExpensesDataStore.dart';
import 'package:ribhi/features/Expenses/data/repo/ExpensesRepoImpl.dart';

import 'package:ribhi/features/reports/data/datasource/RebortDataStore.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';

import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';

import 'package:ribhi/features/sales/data/datastore/saleDataSource.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';

import 'package:ribhi/features/Initialization/data/datasource/SettingLocalData.dart';
import 'package:ribhi/features/auth/presentation/screens/splash_screen.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Repository Interfaces
import 'package:ribhi/features/Dashboard/domain/repo/DashboardRepo.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/reports/domain/repo/reportsRepo.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';
import 'package:ribhi/features/sales/domain/repo/SaleRepo.dart';
import 'package:ribhi/features/auth/domain/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux   ||
      defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
  }

  final db = DatabaseHelper.instance;

  final dashboardRepository = DashboardRepositoryImpl(DashboardLocalDataSourceImpl(db));
  final expensesRepository  = ExpenseRepositoryImpl(ExpenseLocalDataSourceImpl(db));
  final reportsRepository   = ReportsRepositoryImpl(ReportsLocalDataSourceImpl(db));
  final productsRepository  = ProductRepositoryImpl(ProductLocalDataSourceImpl(db));
  final saleRepository      = SaleRepositoryImpl(
    db: db,
    saleLocal: SaleLocalDataSourceImpl(db),
    productLocal: ProductLocalDataSourceImpl(db),
  );

  final settingsDataSource = SettingsLocalDataSourceImpl(db);
  final authLocalService   = AuthLocalService();

  // 🔥 ده المهم بدل Null
  final authRepository = AuthRepositoryImpl(
    authService: FirebaseAuthService(),
  );

  runApp(MyApp(
    dashboardRepository: dashboardRepository,
    expensesRepository: expensesRepository,
    reportsRepository: reportsRepository,
    productsRepository: productsRepository,
    saleRepository: saleRepository,
    productLocalDataSource: ProductLocalDataSourceImpl(db),
    settingsDataSource: settingsDataSource,
    authLocalService: authLocalService,
    authRepository: authRepository, // 👈 مهم
  ));
}

class MyApp extends StatelessWidget {
  final DashboardRepositoryImpl dashboardRepository;
  final ExpenseRepositoryImpl expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;
  final SettingsLocalDataSourceImpl settingsDataSource;
  final AuthLocalService authLocalService;
  final AuthRepositoryImpl authRepository;

  const MyApp({
    super.key,
    required this.dashboardRepository,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
    required this.settingsDataSource,
    required this.authLocalService,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DashboardRepository>(create: (_) => dashboardRepository),
        RepositoryProvider<ExpenseRepository>(create: (_) => expensesRepository),
        RepositoryProvider<ReportsRepository>(create: (_) => reportsRepository),
        RepositoryProvider<ProductRepository>(create: (_) => productsRepository),
        RepositoryProvider<SaleRepository>(create: (_) => saleRepository),
        RepositoryProvider<AuthRepository>(create: (_) => authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DashboardCubit(
              repository: context.read<DashboardRepository>(),
            )..loadStats(),
          ),
          BlocProvider(
            create: (context) => ProductsCubit(
              context.read<ProductRepository>(),
            )..loadProducts(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
              authLocalService: authLocalService,
              settingsDataSource: settingsDataSource,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: SplashScreen(
            expensesRepository: expensesRepository,
            reportsRepository: reportsRepository,
            productsRepository: productsRepository,
            saleRepository: saleRepository,
            productLocalDataSource: productLocalDataSource,
            settingsDataSource: settingsDataSource,
          ),
        ),
      ),
    );
  }
}