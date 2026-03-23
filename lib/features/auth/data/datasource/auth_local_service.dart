import 'package:shared_preferences/shared_preferences.dart';

/// Persists the login state locally using SharedPreferences.
/// Stores only a boolean flag and the store name — no credentials.
class AuthLocalService {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyStoreName  = 'storeName';

  /// Saves login state after a successful sign-in or sign-up.
  Future<void> saveLoginState({required String storeName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyStoreName, storeName);
  }

  /// Returns true if the user is currently logged in.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Returns the saved store name, or null if not logged in.
  Future<String?> getStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStoreName);
  }

  /// Clears all login state (logout).
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyStoreName);
  }
}
