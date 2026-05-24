import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AdminService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  /// =========================
  /// GENERATE SINGLE LICENSE KEY
  /// =========================
  Future<String> generateLicenseKey({
    required String plan,
    required int durationDays,
  }) async {
    String key = _generateRandomKey();

    /// prevent duplicate keys
    final existing =
        await _firestore.collection('license_keys').doc(key).get();

    if (existing.exists) {
      key = _generateRandomKey();
    }

    final keyData = {
      'key': key,
      'plan': plan,
      'durationDays': durationDays,
      'createdAt': FieldValue.serverTimestamp(),
      'isUsed': false,
      'generatedBy': _auth.currentUser?.uid,
    };

    await _firestore
        .collection('license_keys')
        .doc(key)
        .set(keyData);

    return key;
  }

  /// =========================
  /// GENERATE BATCH LICENSE KEYS
  /// =========================
  Future<List<String>> generateBatchLicenseKeys({
    required String plan,
    required int durationDays,
    required int count,
  }) async {
    final keys = <String>[];

    final batch = _firestore.batch();

    for (int i = 0; i < count; i++) {
      String key = _generateRandomKey();

      final existing =
          await _firestore.collection('license_keys').doc(key).get();

      if (existing.exists) {
        key = _generateRandomKey();
      }

      keys.add(key);

      final keyRef =
          _firestore.collection('license_keys').doc(key);

      batch.set(keyRef, {
        'key': key,
        'plan': plan,
        'durationDays': durationDays,
        'createdAt': FieldValue.serverTimestamp(),
        'isUsed': false,
        'generatedBy': _auth.currentUser?.uid,
      });
    }

    await batch.commit();

    return keys;
  }

  /// =========================
  /// DELETE LICENSE KEY
  /// =========================
  Future<void> deleteLicenseKey(String key) async {
    await _firestore
        .collection('license_keys')
        .doc(key)
        .delete();
  }

  /// =========================
  /// GET ALL LICENSE KEYS
  /// =========================
  Future<QuerySnapshot<Map<String, dynamic>>>
      getAllLicenseKeys() async {
    return await _firestore
        .collection('license_keys')
        .get();
  }

  /// =========================
  /// GET ACTIVATED SUBSCRIPTIONS
  /// =========================
  Future<QuerySnapshot<Map<String, dynamic>>>
      getActivatedSubscriptions() async {
    return await _firestore
        .collection('subscriptions')
        .where('active', isEqualTo: true)
        .get();
  }

  /// =========================
  /// GET PENDING PAYMENT REQUESTS
  /// =========================
  Future<QuerySnapshot<Map<String, dynamic>>>
      getPendingPaymentRequests() async {
    return await _firestore
        .collection('payment_requests')
        .get();
  }

  /// =========================
  /// CHECK ADMIN USER
  /// =========================
  Future<bool> isAdminUser({
    String? uid,
  }) async {
    final currentUid =
        uid ?? _auth.currentUser?.uid;

    if (currentUid == null) {
      return false;
    }

    /// check by UID
    final adminDoc = await _firestore
        .collection('admins')
        .doc(currentUid)
        .get();

    if (adminDoc.exists) {
      return true;
    }

    /// fallback by email
    final email =
        _auth.currentUser?.email?.toLowerCase();

    if (email != null) {
      final adminsQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return adminsQuery.docs.isNotEmpty;
    }

    return false;
  }

  /// =========================
  /// DELETE OLD PAYMENT REQUESTS
  /// =========================
  Future<void> deleteOldPaymentRequests(
    int daysOld,
  ) async {
    final cutoffDate =
        DateTime.now().subtract(
      Duration(days: daysOld),
    );

    final query = await _firestore
        .collection('payment_requests')
        .where(
          'createdAt',
          isLessThan: Timestamp.fromDate(cutoffDate),
        )
        .get();

    final batch = _firestore.batch();

    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// =========================
  /// GET SUBSCRIPTION STATISTICS
  /// =========================
  Future<Map<String, dynamic>>
      getSubscriptionStats() async {
    final licenseKeys =
        await getAllLicenseKeys();

    final activatedSubs =
        await getActivatedSubscriptions();

    final pendingRequests =
        await getPendingPaymentRequests();

    final totalKeys =
        licenseKeys.docs.length;

    final usedKeys = licenseKeys.docs
        .where(
          (doc) =>
              (doc.data()['isUsed'] ?? false) == true,
        )
        .length;

    final activeSubs =
        activatedSubs.docs.length;

    final pendingReqs =
        pendingRequests.docs.length;

    return {
      'totalLicenseKeys': totalKeys,
      'usedLicenseKeys': usedKeys,
      'availableLicenseKeys':
          totalKeys - usedKeys,
      'activeSubscriptions': activeSubs,
      'pendingRequests': pendingReqs,
    };
  }

  /// =========================
  /// GENERATE RANDOM KEY
  /// =========================
  String _generateRandomKey() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random = Random();

    String generatePart() {
      return List.generate(
        4,
        (_) => chars[
            random.nextInt(chars.length)],
      ).join();
    }

    return 'RBH-${generatePart()}-${generatePart()}-${generatePart()}';
  }
}