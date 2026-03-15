class ProductFormState {
  final int? productId;
  final String name;
  final String costPrice;
  final String sellPrice;
  final String quantity;
  final String alarmLimit;

  final String? category;
  final String? categoryType;

  final String newCategoryName;
  final bool isAddingCategory;

  final bool isLoading;
  final bool isValid;

  final String? error;
  final bool success;

  final DateTime? createdAt;

  const ProductFormState({
    this.productId,
    this.name = '',
    this.costPrice = '',
    this.sellPrice = '',
    this.quantity = '',
    this.alarmLimit = '',
    this.category,
    this.categoryType = 'piece',
    this.newCategoryName = '',
    this.isAddingCategory = false,
    this.isLoading = false,
    this.isValid = true,
    this.error,
    this.success = false,
    this.createdAt,
  });

  ProductFormState copyWith({
    int? productId,
    String? name,
    String? costPrice,
    String? sellPrice,
    String? quantity,
    String? alarmLimit,
    String? category,
    String? categoryType,
    String? newCategoryName,
    bool? isAddingCategory,
    bool? isLoading,
    bool? isValid,
    String? error,
    bool? success,
    DateTime? createdAt,
  }) {
    return ProductFormState(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      quantity: quantity ?? this.quantity,
      alarmLimit: alarmLimit ?? this.alarmLimit,
      category: category ?? this.category,
      categoryType: categoryType ?? this.categoryType,
      newCategoryName: newCategoryName ?? this.newCategoryName,
      isAddingCategory: isAddingCategory ?? this.isAddingCategory,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      success: success ?? this.success,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}