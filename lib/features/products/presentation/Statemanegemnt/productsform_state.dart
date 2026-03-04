class ProductFormState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const ProductFormState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  ProductFormState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return ProductFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}