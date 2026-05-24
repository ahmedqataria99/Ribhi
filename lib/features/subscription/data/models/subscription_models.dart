import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ribhi/features/subscription/domain/entities/subscription_entities.dart';

class SubscriptionRequestModel extends SubscriptionRequestEntity {
  const SubscriptionRequestModel({
    required super.uid,
    required super.phone,
    required super.transactionId,
    required super.createdAt,
  });

  factory SubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionRequestModel(
      uid: json['uid'] as String,
      phone: json['phone'] as String,
      transactionId: json['transactionId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phone': phone,
      'transactionId': transactionId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class LicenseKeyModel extends LicenseKeyEntity {
  const LicenseKeyModel({
    required super.key,
    required super.plan,
    required super.durationDays,
    required super.createdAt,
  });

  factory LicenseKeyModel.fromJson(Map<String, dynamic> json) {
    return LicenseKeyModel(
      key: json['key'] as String,
      plan: json['plan'] as String,
      durationDays: json['durationDays'] as int,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'plan': plan,
      'durationDays': durationDays,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class UserSubscriptionModel extends UserSubscriptionEntity {
  const UserSubscriptionModel({
    required super.active,
    required super.plan,
    required super.expiryDate,
    super.lastBackup,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      active: json['active'] as bool,
      plan: json['plan'] as String,
      expiryDate: (json['expiryDate'] as Timestamp).toDate(),
      lastBackup: json['lastBackup'] != null
          ? (json['lastBackup'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'plan': plan,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'lastBackup': lastBackup != null ? Timestamp.fromDate(lastBackup!) : null,
    };
  }
}
