import 'package:bloc/bloc.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

import '../../domain/entities/products.dart';
import '../../domain/repo/ProductRepo.dart';
import 'products_cubit.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final ProductRepository repository;
  final ProductsCubit productsCubit;

  ProductFormCubit(this.repository, this.productsCubit)
      : super(const ProductFormState());

  /// Reset
  void resetState() {
    emit(const ProductFormState());
  }

  /// Initialize for edit
  void initializeForEdit(Product product) {
    emit(
      ProductFormState(
        productId: product.id,
        name: product.name,
        costPrice: product.costPrice.toString(),
        sellPrice: product.sellPrice.toString(),
        quantity: product.quantity.toString(),
        category: product.category,
        categoryType: (product.categoryType ?? 'piece').toLowerCase(),
        createdAt: product.createdAt,
        isValid: true,
      ),
    );
  }

  /// Validation
  bool _validate({
    required String name,
    required String costPrice,
    required String sellPrice,
    required String quantity,
    required String alarmLimit,
  }) {
    return name.isNotEmpty &&
        double.tryParse(costPrice) != null &&
        double.tryParse(sellPrice) != null &&
        int.tryParse(quantity) != null &&
        (alarmLimit.isEmpty || int.tryParse(alarmLimit) != null);
  }

  /// Update Fields

  void updateName(String value) {
    final isValid = _validate(
      name: value,
      costPrice: state.costPrice,
      sellPrice: state.sellPrice,
      quantity: state.quantity,
      alarmLimit: state.alarmLimit,
    );

    emit(state.copyWith(name: value, isValid: isValid));
  }

  void updateCostPrice(String value) {
    final isValid = _validate(
      name: state.name,
      costPrice: value,
      sellPrice: state.sellPrice,
      quantity: state.quantity,
      alarmLimit: state.alarmLimit,
    );

    emit(state.copyWith(costPrice: value, isValid: isValid));
  }

  void updateSellPrice(String value) {
    final isValid = _validate(
      name: state.name,
      costPrice: state.costPrice,
      sellPrice: value,
      quantity: state.quantity,
      alarmLimit: state.alarmLimit,
    );

    emit(state.copyWith(sellPrice: value, isValid: isValid));
  }

  void updateQuantity(String value) {
    final isValid = _validate(
      name: state.name,
      costPrice: state.costPrice,
      sellPrice: state.sellPrice,
      quantity: value,
      alarmLimit: state.alarmLimit,
    );

    emit(state.copyWith(quantity: value, isValid: isValid));
  }

  void updateAlarmLimit(String value) {
    final isValid = _validate(
      name: state.name,
      costPrice: state.costPrice,
      sellPrice: state.sellPrice,
      quantity: state.quantity,
      alarmLimit: value,
    );

    emit(state.copyWith(alarmLimit: value, isValid: isValid));
  }

  /// Category

  void selectCategory(String category) {
    emit(state.copyWith(category: category));
  }

  void toggleAddCategory() {
    emit(state.copyWith(isAddingCategory: !state.isAddingCategory));
  }

  /// Add Category Form

  void updateNewCategoryName(String value) {
    emit(state.copyWith(newCategoryName: value));
  }

  void selectCategoryType(String type) {
    emit(state.copyWith(categoryType: type.toLowerCase()));
  }

  Future<void> addCategory() async {
    if (state.newCategoryName.isEmpty || state.categoryType == null) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final trimmedName = state.newCategoryName.trim();

      final existingCategories =
          await productsCubit.repository.getCategories();

      if (existingCategories.contains(trimmedName)) {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Category already exists',
          ),
        );
        return;
      }

      await repository.addCategory(
        name: trimmedName,
        type: state.categoryType!,
      );

      await productsCubit.loadProducts();

      emit(
        state.copyWith(
          isLoading: false,
          isAddingCategory: false,
          category: trimmedName,
          newCategoryName: '',
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to add category: $e',
        ),
      );
    }
  }

  /// Add Product

  Future<void> addProduct() async {
    if (!state.isValid) return;

    emit(state.copyWith(isLoading: true, error: null, success: false));

    try {
      final product = Product(
        name: state.name.trim(),
        costPrice: double.parse(state.costPrice),
        sellPrice: double.parse(state.sellPrice),
        quantity: int.parse(state.quantity),
        category: (state.category ?? "Other").trim(),
        categoryType: state.categoryType,
        minStockLevel: state.alarmLimit.isEmpty ? 0 : int.parse(state.alarmLimit),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.add(product);

      await productsCubit.loadProducts();

      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error adding product: $e',
        ),
      );
    }
  }

  /// Update Product

  Future<void> updateProduct() async {
    if (!state.isValid || state.productId == null) return;

    emit(state.copyWith(isLoading: true, error: null, success: false));

    try {
      final product = Product(
        id: state.productId,
        name: state.name.trim(),
        costPrice: double.parse(state.costPrice),
        sellPrice: double.parse(state.sellPrice),
        quantity: int.parse(state.quantity),
        category: (state.category ?? "Other").trim(),
        categoryType: state.categoryType,
        minStockLevel: state.alarmLimit.isEmpty ? 0 : int.parse(state.alarmLimit),
        createdAt: state.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.update(product);

      await productsCubit.loadProducts();

      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error updating product: $e',
        ),
      );
    }
  }

  void loadProduct(Product product) {
    emit(
      state.copyWith(
        productId: product.id,
        name: product.name,
        costPrice: product.costPrice.toString(),
        sellPrice: product.sellPrice.toString(),
        quantity: product.quantity.toString(),
        alarmLimit: product.minStockLevel.toString(),
        category: product.category,
        categoryType: product.categoryType,
        createdAt: product.createdAt,
        isValid: true,
      ),
    );
  }
}