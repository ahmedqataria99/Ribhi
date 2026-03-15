import 'package:bloc/bloc.dart';
import '../../domain/repo/ProductRepo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository repository;

  ProductsCubit(this.repository) : super(const ProductsState());

  /// load products and apply current filters
  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true));

    try {
      final products = await repository.getAll();
      final categories = await repository.getCategories();

      // Combine product categories with database categories
      final allCategories = <String>{
        ...categories.map((c) => c.trim()),
        ...products.map((p) => p.category.trim()),
      }.toList();

      // Reapply current filters
      final filtered = products.where((product) {
        final matchesCategory =
            state.selectedCategory == null ||
            product.category.trim() == state.selectedCategory!.trim();

        final matchesSearch = product.name.toLowerCase().contains(
          state.searchQuery.toLowerCase().trim(),
        );

        return matchesCategory && matchesSearch;
      }).toList();

      emit(
        state.copyWith(
          products: products,
          filteredProducts: filtered,
          isLoading: false,
          categories: allCategories,
        ),
      );
    } catch (e) {
      print('Load Products Error: $e');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// search
  void search(String query) {
    final filtered = state.products.where((product) {
      final matchesName = product.name.toLowerCase().contains(
        query.toLowerCase().trim(),
      );

      final matchesCategory =
          state.selectedCategory == null ||
          product.category.trim() == state.selectedCategory!.trim();

      return matchesName && matchesCategory;
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredProducts: filtered));
  }

  /// filter
  void filterByCategory(String? category) {

  final filtered = state.products.where((product) {

    if (category == null) return true;

    return product.category == category;

  }).toList();

  emit(
    state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
      filteredProducts: filtered,
    ),
  );
}
  /// delete product
  Future<void> deleteProduct(int id) async {
    emit(state.copyWith(isDeleting: true));

    try {
      await repository.delete(id);

      emit(state.copyWith(isDeleting: false, deleteSuccess: true));

      await loadProducts();
    } catch (e) {
      emit(state.copyWith(isDeleting: false, error: e.toString()));
    }
  }

  /// categories
  List<String> get categories {
    return state.categories;
  }
  Future<void> deleteCategory(String category) async {
  await repository.deleteCategory(category);

  loadProducts(); // يعيد تحميل المنتجات و الكاتيجوري
}

void updateCategory(String oldName, String newName) {
  final updated = state.categories.map((c) {
    if (c == oldName) {
      return newName;
    }
    return c;
  }).toList();

  emit(state.copyWith(categories: updated));
}
}
