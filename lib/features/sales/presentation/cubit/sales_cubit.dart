import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';
import 'package:ribhi/features/sales/domain/repo/SaleRepo.dart';
import 'package:ribhi/features/sales/presentation/cubit/sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  final SaleRepository saleRepo;
  final ProductLocalDataSource productLocal; // Usually accessed via a ProductRepo

  SalesCubit(this.saleRepo, this.productLocal) : super(SalesState()) {
    loadTodaySummary();
  }

  // 1. Load the Top Card Data using your getTodaySales()
  Future<void> loadTodaySummary() async {
    final sales = await saleRepo.getTodaySales();
    final total = sales.fold(0.0, (sum, item) => sum + item.amount);
    emit(state.copyWith(
      todayTotalAmount: total,
      todayTransactionsCount: sales.length,
    ));
  }

  // 2. Search logic using your ProductLocalDataSource
  Future<void> searchProduct(String query) async {

  final results = await productLocal.search(query);

  if (results.isNotEmpty) {
    emit(state.copyWith(
      uiState: 1, // This triggers: if (state.uiState == 1) _buildDropdownList
      searchResults: results.map((model) => model.toEntity()).toList(),
    ));
  } else {
    emit(state.copyWith(uiState: 0, searchResults: []));
  }
  }

  void selectProduct(Product product) {
    emit(state.copyWith(selectedProduct: product, uiState: 2, quantity: 1));
  }

  // 3. Confirm Sale using your Repository implementation
  Future<void> confirmSale() async {
    if (state.selectedProduct == null) return;
    
    emit(state.copyWith(status: SalesStatus.loading));
    try {
      await saleRepo.createSale(
        productId: state.selectedProduct!.id!,
        quantity: state.quantity,
      );
      // Refresh summary and reset UI
      await loadTodaySummary();
      emit(state.copyWith(status: SalesStatus.success, uiState: 0, selectedProduct: null));
    } catch (e) {
      emit(state.copyWith(status: SalesStatus.error, error: e.toString()));
    }
  }

  void increment() => emit(state.copyWith(quantity: state.quantity + 1));
  void decrement() => state.quantity > 1 ? emit(state.copyWith(quantity: state.quantity - 1)) : null;

  void reset() => emit(SalesState());

}