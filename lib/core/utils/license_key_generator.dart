import 'dart:math';

class LicenseKeyGenerator {
  static const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final Random _random = Random.secure();

  static String generateKey() {
    final groups = List.generate(4, (_) => _generateGroup(4));
    return 'RBH-${groups.join('-')}';
  }

  static String _generateGroup(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
      ),
    );
  }

  static int getDurationDays(String plan) {
    switch (plan.toLowerCase()) {
      case 'monthly':
        return 30;
      case 'yearly':
        return 365;
      case 'lifetime':
        return 365 * 10; // 10 years
      default:
        return 30;
    }
  }

  static String getPlanFromDuration(int days) {
    if (days >= 365 * 10) return 'lifetime';
    if (days >= 365) return 'yearly';
    return 'monthly';
  }
}
