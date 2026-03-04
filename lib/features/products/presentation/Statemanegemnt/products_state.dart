import '../../domain/entities/products.dart';

class ProductsState {
  final List<Product> products;
  final List<Product> filteredProducts;

  final bool isLoading;
  final bool isDeleting;

  final String searchQuery;
  final String? selectedCategory;

  final bool deleteSuccess;

  final String? error;

  const ProductsState({
    this.products = const [],
    this.filteredProducts = const [],
    this.isLoading = false,
    this.isDeleting = false,
    this.deleteSuccess = false,
    this.searchQuery = '',
    this.selectedCategory,
    this.error,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    bool? isLoading,
    bool? isDeleting,
    bool? deleteSuccess,
    String? searchQuery,
    String? selectedCategory,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      deleteSuccess: deleteSuccess ?? false,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }
}