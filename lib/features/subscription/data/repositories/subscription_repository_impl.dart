import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/subscription/data/datasource/subscription_remote_datasource.dart';
import 'package:ribhi/features/subscription/data/models/subscription_models.dart';
import 'package:ribhi/features/subscription/domain/entities/subscription_entities.dart';
import 'package:ribhi/features/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;
  final FirebaseAuth auth;

  SubscriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.auth,
  });

  @override
  Future<Either<Faliur, void>> submitPaymentRequest({
    required String phone,
    required String transactionId,
  }) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Left(Faliur(errmessage: 'User not authenticated'));
      }
      await remoteDataSource.submitPaymentRequest(
        uid: uid,
        phone: phone,
        transactionId: transactionId,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to submit payment request: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Faliur, void>> activateLicenseKey(String key) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Left(Faliur(errmessage: 'User not authenticated'));
      }

      // Get license key
      final licenseKey = await remoteDataSource.getLicenseKey(key);
      if (licenseKey == null) {
        return Left(Faliur(errmessage: 'Invalid license key'));
      }

      // Calculate expiry date
      final expiryDate = DateTime.now().add(
        Duration(days: licenseKey.durationDays),
      );

      // Get current subscription or create new
      final currentSub = await remoteDataSource.getUserSubscription(uid);
      final newSubscription = UserSubscriptionModel(
        active: true,
        plan: licenseKey.plan,
        expiryDate: expiryDate,
        lastBackup: currentSub?.lastBackup,
      );

      // Update user subscription
      await remoteDataSource.updateUserSubscription(uid, newSubscription);

      // Delete the license key
      await remoteDataSource.deleteLicenseKey(key);

      return const Right(null);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to activate license: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Faliur, UserSubscriptionEntity?>> getUserSubscription() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Left(Faliur(errmessage: 'User not authenticated'));
      }
      final subscription = await remoteDataSource.getUserSubscription(uid);
      return Right(subscription);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to get subscription: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Faliur, bool>> isPremiumUser() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return const Right(false);
      }
      final subscription = await remoteDataSource.getUserSubscription(uid);
      if (subscription == null) {
        return const Right(false);
      }
      return Right(
        subscription.active && subscription.expiryDate.isAfter(DateTime.now()),
      );
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to check premium status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Faliur, void>> updateLastBackup(DateTime timestamp) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Left(Faliur(errmessage: 'No authenticated user found'));
      }
      final currentSub = await remoteDataSource.getUserSubscription(uid);
      if (currentSub != null) {
        final updatedSub = UserSubscriptionModel(
          active: currentSub.active,
          plan: currentSub.plan,
          expiryDate: currentSub.expiryDate,
          lastBackup: timestamp,
        );
        await remoteDataSource.updateUserSubscription(uid, updatedSub);
      }
      return const Right(null);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to update last backup: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Faliur, void>> cleanupOldPaymentRequests(int daysOld) async {
    try {
      await remoteDataSource.cleanupOldPaymentRequests(daysOld);
      return const Right(null);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to cleanup old requests: ${e.toString()}'),
      );
    }
  }
}
