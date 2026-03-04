import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/database/databaseHelper.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/domain/repo/ProductRepo.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/UI/screens/ProductsScreen.dart';

void main() {
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
        debugShowCheckedModeBanner: false,
        title: 'ribhi', home: const ProductsPage()),
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
