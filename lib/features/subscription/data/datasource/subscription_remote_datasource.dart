import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ribhi/features/subscription/data/models/subscription_models.dart';

abstract class SubscriptionRemoteDataSource {
  Future<void> submitPaymentRequest({
    required String uid,
    required String phone,
    required String transactionId,
  });

  Future<LicenseKeyModel?> getLicenseKey(String key);

  Future<void> deleteLicenseKey(String key);

  Future<UserSubscriptionModel?> getUserSubscription(String uid);

  Future<void> updateUserSubscription(
    String uid,
    UserSubscriptionModel subscription,
  );

  Future<void> cleanupOldPaymentRequests(int daysOld);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SubscriptionRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> submitPaymentRequest({
    required String uid,
    required String phone,
    required String transactionId,
  }) async {
    final request = SubscriptionRequestModel(
      uid: uid,
      phone: phone,
      transactionId: transactionId,
      createdAt: DateTime.now(),
    );

    await firestore.collection('subscription_requests').add(request.toJson());
  }

  @override
  Future<LicenseKeyModel?> getLicenseKey(String key) async {
    final doc = await firestore.collection('license_keys').doc(key).get();
    if (doc.exists) {
      return LicenseKeyModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> deleteLicenseKey(String key) async {
    await firestore.collection('license_keys').doc(key).delete();
  }

  @override
  Future<UserSubscriptionModel?> getUserSubscription(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data()!['subscription'] != null) {
      return UserSubscriptionModel.fromJson(doc.data()!['subscription']);
    }
    return null;
  }

  @override
  Future<void> updateUserSubscription(
    String uid,
    UserSubscriptionModel subscription,
  ) async {
    await firestore.collection('users').doc(uid).update({
      'subscription': subscription.toJson(),
    });
  }

  @override
  Future<void> cleanupOldPaymentRequests(int daysOld) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final query = await firestore
        .collection('subscription_requests')
        .where('createdAt', isLessThan: Timestamp.fromDate(cutoffDate))
        .get();

    final batch = firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
