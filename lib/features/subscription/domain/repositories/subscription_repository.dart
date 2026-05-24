import 'package:dartz/dartz.dart';
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/subscription/domain/entities/subscription_entities.dart';

abstract class SubscriptionRepository {
  Future<Either<Faliur, void>> submitPaymentRequest({
    required String phone,
    required String transactionId,
  });

  Future<Either<Faliur, void>> activateLicenseKey(String key);

  Future<Either<Faliur, UserSubscriptionEntity?>> getUserSubscription();

  Future<Either<Faliur, bool>> isPremiumUser();

  Future<Either<Faliur, void>> updateLastBackup(DateTime timestamp);

  Future<Either<Faliur, void>> cleanupOldPaymentRequests(int daysOld);
}
