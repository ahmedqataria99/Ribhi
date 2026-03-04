import 'package:bloc/bloc.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/productsform_state.dart';

import '../../domain/entities/products.dart';
import '../../domain/repo/ProductRepo.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final ProductRepository repository;

  ProductFormCubit(this.repository)
      : super(const ProductFormState());

  /// Add Product
  Future<void> addProduct(Product product) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await repository.add(product);

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Update Product
  Future<void> updateProduct(Product product) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await repository.update(product);

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: e.toString(),
        ),
      );
    }
  }
}