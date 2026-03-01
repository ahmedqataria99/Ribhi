class Settings {
  final int? id;
  final String storeName;
  final double initialCapital;
  final String currency;
  final bool isActivated;
  final String? licenseKey;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Settings({
    this.id,
    required this.storeName,
    required this.initialCapital,
    required this.currency,
    required this.isActivated,
    this.licenseKey,
    required this.createdAt,
    required this.updatedAt,
  });

  Settings copyWith({
    String? storeName,
    double? initialCapital,
    String? currency,
    bool? isActivated,
    String? licenseKey,
    DateTime? updatedAt,
  }) {
    return Settings(
      id: id,
      storeName: storeName ?? this.storeName,
      initialCapital: initialCapital ?? this.initialCapital,
      currency: currency ?? this.currency,
      isActivated: isActivated ?? this.isActivated,
      licenseKey: licenseKey ?? this.licenseKey,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}