import 'package:equatable/equatable.dart';

class SubscriptionRequestEntity extends Equatable {
  final String uid;
  final String phone;
  final String transactionId;
  final DateTime createdAt;

  const SubscriptionRequestEntity({
    required this.uid,
    required this.phone,
    required this.transactionId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, phone, transactionId, createdAt];
}

class LicenseKeyEntity extends Equatable {
  final String key;
  final String plan;
  final int durationDays;
  final DateTime createdAt;

  const LicenseKeyEntity({
    required this.key,
    required this.plan,
    required this.durationDays,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [key, plan, durationDays, createdAt];
}

class UserSubscriptionEntity extends Equatable {
  final bool active;
  final String plan;
  final DateTime expiryDate;
  final DateTime? lastBackup;

  const UserSubscriptionEntity({
    required this.active,
    required this.plan,
    required this.expiryDate,
    this.lastBackup,
  });

  @override
  List<Object?> get props => [active, plan, expiryDate, lastBackup];
}
