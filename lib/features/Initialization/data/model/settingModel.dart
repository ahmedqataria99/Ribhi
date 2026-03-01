import 'package:ribhi/features/Initialization/domain/entity/Settings.dart';

class SettingsModel {
  final int? id;
  final String storeName;
  final double initialCapital;
  final String currency;
  final int isActivated;
  final String? licenseKey;
  final DateTime createdAt;
  final DateTime updatedAt;

  SettingsModel({
    this.id,
    required this.storeName,
    required this.initialCapital,
    required this.currency,
    required this.isActivated,
    this.licenseKey,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map['id'],
      storeName: map['store_name'],
      initialCapital: (map['initial_capital'] as num).toDouble(),
      currency: map['currency'],
      isActivated: map['is_activated'],
      licenseKey: map['license_key'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'store_name': storeName,
      'initial_capital': initialCapital,
      'currency': currency,
      'is_activated': isActivated,
      'license_key': licenseKey,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Settings toEntity() {
    return Settings(
      id: id,
      storeName: storeName,
      initialCapital: initialCapital,
      currency: currency,
      isActivated: isActivated == 1,
      licenseKey: licenseKey,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SettingsModel.fromEntity(Settings entity) {
    return SettingsModel(
      id: entity.id,
      storeName: entity.storeName,
      initialCapital: entity.initialCapital,
      currency: entity.currency,
      isActivated: entity.isActivated ? 1 : 0,
      licenseKey: entity.licenseKey,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}