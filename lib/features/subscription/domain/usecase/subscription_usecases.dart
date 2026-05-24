import 'package:dartz/dartz.dart';
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/subscription/domain/entities/subscription_entities.dart';
import 'package:ribhi/features/subscription/domain/repositories/subscription_repository.dart';

class SubmitPaymentRequestUseCase {
  final SubscriptionRepository repository;

  SubmitPaymentRequestUseCase(this.repository);

  Future<Either<Faliur, void>> call({
    required String phone,
    required String transactionId,
  }) {
    return repository.submitPaymentRequest(
      phone: phone,
      transactionId: transactionId,
    );
  }
}

class ActivateLicenseKeyUseCase {
  final SubscriptionRepository repository;

  ActivateLicenseKeyUseCase(this.repository);

  Future<Either<Faliur, void>> call(String key) {
    return repository.activateLicenseKey(key);
  }
}

class GetUserSubscriptionUseCase {
  final SubscriptionRepository repository;

  GetUserSubscriptionUseCase(this.repository);

  Future<Either<Faliur, UserSubscriptionEntity?>> call() {
    return repository.getUserSubscription();
  }
}

class IsPremiumUserUseCase {
  final SubscriptionRepository repository;

  IsPremiumUserUseCase(this.repository);

  Future<Either<Faliur, bool>> call() {
    return repository.isPremiumUser();
  }
}

class UpdateLastBackupUseCase {
  final SubscriptionRepository repository;

  UpdateLastBackupUseCase(this.repository);

  Future<Either<Faliur, void>> call(DateTime timestamp) {
    return repository.updateLastBackup(timestamp);
  }
}

class CleanupOldPaymentRequestsUseCase {
  final SubscriptionRepository repository;

  CleanupOldPaymentRequestsUseCase(this.repository);

  Future<Either<Faliur, void>> call(int daysOld) {
    return repository.cleanupOldPaymentRequests(daysOld);
  }
}
