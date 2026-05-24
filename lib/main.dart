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

// Subscription imports
import 'package:ribhi/features/subscription/data/datasource/subscription_remote_datasource.dart';
import 'package:ribhi/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:ribhi/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:ribhi/features/subscription/domain/usecase/subscription_usecases.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_cubit.dart';

// Backup imports
import 'package:ribhi/features/backup/data/datasource/backup_datasource.dart';
import 'package:ribhi/features/backup/data/repositories/backup_repository_impl.dart';
import 'package:ribhi/features/backup/domain/repositories/backup_repository.dart';
import 'package:ribhi/features/backup/domain/usecase/backup_usecases.dart';
import 'package:ribhi/features/backup/presentation/cubit/backup_cubit.dart';

// Firebase services
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:ribhi/core/security/admin_guard.dart';
import 'package:ribhi/features/subscription/data/services/admin_service.dart';
import 'package:ribhi/features/subscription/presentation/screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final db = DatabaseHelper.instance;

  final dashboardRepository = DashboardRepositoryImpl(
    DashboardLocalDataSourceImpl(db),
  );
  final expensesRepository = ExpenseRepositoryImpl(
    ExpenseLocalDataSourceImpl(db),
  );
  final reportsRepository = ReportsRepositoryImpl(
    ReportsLocalDataSourceImpl(db),
  );
  final productsRepository = ProductRepositoryImpl(
    ProductLocalDataSourceImpl(db),
  );
  final saleRepository = SaleRepositoryImpl(
    db: db,
    saleLocal: SaleLocalDataSourceImpl(db),
    productLocal: ProductLocalDataSourceImpl(db),
  );

  final settingsDataSource = SettingsLocalDataSourceImpl(db);
  final authLocalService = AuthLocalService();

  // 🔥 ده المهم بدل Null
  final authRepository = AuthRepositoryImpl(authService: FirebaseAuthService());

  // Subscription services
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final subscriptionRemoteDataSource = SubscriptionRemoteDataSourceImpl(
    firestore: firestore,
    auth: auth,
  );
  final subscriptionRepository = SubscriptionRepositoryImpl(
    remoteDataSource: subscriptionRemoteDataSource,
    auth: auth,
  );

  // Backup services
  final storage = FirebaseStorage.instance;
  final connectivity = Connectivity();
  final backupRemoteDataSource = BackupRemoteDataSourceImpl(
    storage: storage,
    auth: auth,
  );
  final backupLocalDataSource = BackupLocalDataSource(db);
  final connectivityDataSource = ConnectivityDataSource(connectivity);
  final backupRepository = BackupRepositoryImpl(
    remoteDataSource: backupRemoteDataSource,
    localDataSource: backupLocalDataSource,
    connectivityDataSource: connectivityDataSource,
    subscriptionRepository: subscriptionRepository,
    auth: auth,
  );

  final adminService = AdminService(firestore: firestore, auth: auth);

  // Use cases
  final submitPaymentRequestUseCase = SubmitPaymentRequestUseCase(
    subscriptionRepository,
  );
  final activateLicenseKeyUseCase = ActivateLicenseKeyUseCase(
    subscriptionRepository,
  );
  final getUserSubscriptionUseCase = GetUserSubscriptionUseCase(
    subscriptionRepository,
  );
  final isPremiumUserUseCase = IsPremiumUserUseCase(subscriptionRepository);
  final updateLastBackupUseCase = UpdateLastBackupUseCase(
    subscriptionRepository,
  );
  final cleanupOldPaymentRequestsUseCase = CleanupOldPaymentRequestsUseCase(
    subscriptionRepository,
  );

  final uploadBackupUseCase = UploadBackupUseCase(backupRepository);
  final restoreBackupUseCase = RestoreBackupUseCase(backupRepository);
  final hasInternetConnectionUseCase = HasInternetConnectionUseCase(
    backupRepository,
  );

  runApp(
    MyApp(
      dashboardRepository: dashboardRepository,
      expensesRepository: expensesRepository,
      reportsRepository: reportsRepository,
      productsRepository: productsRepository,
      saleRepository: saleRepository,
      productLocalDataSource: ProductLocalDataSourceImpl(db),
      settingsDataSource: settingsDataSource,
      authLocalService: authLocalService,
      authRepository: authRepository, // 👈 مهم
      subscriptionRepository: subscriptionRepository,
      backupRepository: backupRepository,
      adminService: adminService,
      submitPaymentRequestUseCase: submitPaymentRequestUseCase,
      activateLicenseKeyUseCase: activateLicenseKeyUseCase,
      getUserSubscriptionUseCase: getUserSubscriptionUseCase,
      isPremiumUserUseCase: isPremiumUserUseCase,
      updateLastBackupUseCase: updateLastBackupUseCase,
      cleanupOldPaymentRequestsUseCase: cleanupOldPaymentRequestsUseCase,
      uploadBackupUseCase: uploadBackupUseCase,
      restoreBackupUseCase: restoreBackupUseCase,
      hasInternetConnectionUseCase: hasInternetConnectionUseCase,
    ),
  );
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
  final SubscriptionRepository subscriptionRepository;
  final BackupRepository backupRepository;
  final AdminService adminService;
  final SubmitPaymentRequestUseCase submitPaymentRequestUseCase;
  final ActivateLicenseKeyUseCase activateLicenseKeyUseCase;
  final GetUserSubscriptionUseCase getUserSubscriptionUseCase;
  final IsPremiumUserUseCase isPremiumUserUseCase;
  final UpdateLastBackupUseCase updateLastBackupUseCase;
  final CleanupOldPaymentRequestsUseCase cleanupOldPaymentRequestsUseCase;
  final UploadBackupUseCase uploadBackupUseCase;
  final RestoreBackupUseCase restoreBackupUseCase;
  final HasInternetConnectionUseCase hasInternetConnectionUseCase;

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
    required this.subscriptionRepository,
    required this.backupRepository,
    required this.adminService,
    required this.submitPaymentRequestUseCase,
    required this.activateLicenseKeyUseCase,
    required this.getUserSubscriptionUseCase,
    required this.isPremiumUserUseCase,
    required this.updateLastBackupUseCase,
    required this.cleanupOldPaymentRequestsUseCase,
    required this.uploadBackupUseCase,
    required this.restoreBackupUseCase,
    required this.hasInternetConnectionUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DashboardRepository>(
          create: (_) => dashboardRepository,
        ),
        RepositoryProvider<ExpenseRepository>(
          create: (_) => expensesRepository,
        ),
        RepositoryProvider<ReportsRepository>(create: (_) => reportsRepository),
        RepositoryProvider<ProductRepository>(
          create: (_) => productsRepository,
        ),
        RepositoryProvider<SaleRepository>(create: (_) => saleRepository),
        RepositoryProvider<AuthRepository>(create: (_) => authRepository),
        RepositoryProvider<SubscriptionRepository>(
          create: (_) => subscriptionRepository,
        ),
        RepositoryProvider<BackupRepository>(create: (_) => backupRepository),
        RepositoryProvider<AdminService>(create: (_) => adminService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DashboardCubit(repository: context.read<DashboardRepository>())
                  ..loadStats(),
          ),
          BlocProvider(
            create: (context) =>
                ProductsCubit(context.read<ProductRepository>())
                  ..loadProducts(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
              authLocalService: authLocalService,
              settingsDataSource: settingsDataSource,
            ),
          ),
          BlocProvider(
            create: (context) => SubscriptionCubit(
              submitPaymentRequestUseCase: submitPaymentRequestUseCase,
              activateLicenseKeyUseCase: activateLicenseKeyUseCase,
              getUserSubscriptionUseCase: getUserSubscriptionUseCase,
              isPremiumUserUseCase: isPremiumUserUseCase,
              updateLastBackupUseCase: updateLastBackupUseCase,
              cleanupOldPaymentRequestsUseCase:
                  cleanupOldPaymentRequestsUseCase,
            )..loadSubscriptionStatus(),
          ),
          BlocProvider(
            create: (context) => BackupCubit(
              uploadBackupUseCase: uploadBackupUseCase,
              restoreBackupUseCase: restoreBackupUseCase,
              hasInternetConnectionUseCase: hasInternetConnectionUseCase,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routes: {'/admin': (context) => AdminGuard.adminRoute(context)},
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
