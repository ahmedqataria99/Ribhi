import 'package:bloc/bloc.dart';
import '../../domain/repo/ProductRepo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository repository;

  ProductsCubit(this.repository) : super(const ProductsState());

  /// load products
  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true));

    try {
      final products = await repository.getAll();

      emit(
        state.copyWith(
          products: products,
          filteredProducts: products,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// search
  void search(String query) {
    final filtered = state.products.where((product) {
      final matchesName =
          product.name.toLowerCase().contains(query.toLowerCase());

      final matchesCategory =
          state.selectedCategory == null ||
              product.category == state.selectedCategory;

      return matchesName && matchesCategory;
    }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        filteredProducts: filtered,
      ),
    );
  }

  /// filter
  void filterByCategory(String? category) {
    final filtered = state.products.where((product) {
      final matchesCategory =
          category == null || product.category == category;

      final matchesSearch = product.name
          .toLowerCase()
          .contains(state.searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    emit(
      state.copyWith(
        selectedCategory: category,
        filteredProducts: filtered,
      ),
    );
  }

  /// delete product
  Future<void> deleteProduct(int id) async {
    emit(state.copyWith(isDeleting: true));

    try {
      await repository.delete(id);

      emit(
        state.copyWith(
          isDeleting: false,
          deleteSuccess: true,
        ),
      );

      await loadProducts();

    } catch (e) {

      emit(
        state.copyWith(
          isDeleting: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// categories
  List<String> get categories {
    return state.products
        .map((product) => product.category)
        .toSet()
        .toList();
  }
}