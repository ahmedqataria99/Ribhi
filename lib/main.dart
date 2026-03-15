import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/database/databaseHelper.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/UI/screens/ProductsScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }else{
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  }
  runApp(const Ribhi());
}

class Ribhi extends StatelessWidget {
  const Ribhi({super.key});

  @override
  Widget build(BuildContext context) {
    // set up dependencies once
    final database = DatabaseHelper.instance;
    final localSource = ProductLocalDataSourceImpl(database);
    final ProductRepository repository = ProductRepositoryImpl(localSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(create: (_) => repository),
      ],
      child: MaterialApp(
        theme: ThemeData(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        debugShowCheckedModeBanner: false,
        title: 'ribhi',
        home: const ProductsPage(),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsCubit(context.read<ProductRepository>())..loadProducts(),
      child: const ProductsScreen(),
    );
  }
}
