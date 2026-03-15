import '../../domain/entities/products.dart';

class ProductsState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;

  final bool isLoading;
  final bool isDeleting;

  final String searchQuery;
  final String? selectedCategory;

  final bool deleteSuccess;

  final String? error;

  const ProductsState({
    this.products = const [],
    this.filteredProducts = const [],
    this.categories = const [],
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
  List<String>? categories,
  bool? isLoading,
  bool? isDeleting,
  bool? deleteSuccess,
  String? searchQuery,
  String? selectedCategory,
  bool clearCategory = false,
  String? error,
}) {
  return ProductsState(
    products: products ?? this.products,
    filteredProducts: filteredProducts ?? this.filteredProducts,
    categories: categories ?? this.categories,
    isLoading: isLoading ?? this.isLoading,
    isDeleting: isDeleting ?? this.isDeleting,
    deleteSuccess: deleteSuccess ?? false,
    searchQuery: searchQuery ?? this.searchQuery,

    selectedCategory: clearCategory
        ? null
        : selectedCategory ?? this.selectedCategory,

    error: error,
  );
}
}
