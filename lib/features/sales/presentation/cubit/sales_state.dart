import 'package:ribhi/features/products/domain/entities/products.dart';

enum SalesStatus { initial, loading, success, error }

class SalesState {
  final SalesStatus status;
  // Today's summary
  final double todayTotalAmount;
  final int todayTransactionsCount;
  // Search results
  final List<Product> searchResults;
  final Product? selectedProduct;
  final int quantity;
  final int uiState; // 0: Initial, 1: Searching, 2: Selected
  final String? error;

  double get total {
    if (selectedProduct == null) return 0.0;
    return selectedProduct!.sellPrice * quantity;
  }

  SalesState({
    this.status = SalesStatus.initial,
    this.todayTotalAmount = 0,
    this.todayTransactionsCount = 0,
    this.searchResults = const [],
    this.selectedProduct,
    this.quantity = 1,
    this.uiState = 0,
    this.error,
  });

  SalesState copyWith({
    SalesStatus? status,
    double? todayTotalAmount,
    int? todayTransactionsCount,
    List<Product>? searchResults,
    Product? selectedProduct,
    int? quantity,
    int? uiState,
    String? error,
  }) {
    return SalesState(
      status: status ?? this.status,
      todayTotalAmount: todayTotalAmount ?? this.todayTotalAmount,
      todayTransactionsCount: todayTransactionsCount ?? this.todayTransactionsCount,
      searchResults: searchResults ?? this.searchResults,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      quantity: quantity ?? this.quantity,
      uiState: uiState ?? this.uiState,
      error: error,
    );
  }
}