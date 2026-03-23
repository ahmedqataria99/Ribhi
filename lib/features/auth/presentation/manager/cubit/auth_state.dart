abstract class AuthState {}

class AuthInitial extends AuthState {}

// --- Email verification states (existing) ---
class CheckEmailVerificationInProgress extends AuthState {}
class AuthEmailVerifiedSuccess extends AuthState {}
class AuthEmailNotVerifiedYet extends AuthState {}

// --- App-level auth states (new) ---

/// Emitted while checking SharedPreferences at startup.
class AppAuthChecking extends AuthState {}

/// Emitted when the user is confirmed to be logged in.
class AppAuthAuthenticated extends AuthState {}

/// Emitted when the user is NOT logged in.
class AppAuthUnauthenticated extends AuthState {}

/// Emitted during a sign-in attempt.
class AppAuthLoginLoading extends AuthState {}

/// Emitted after a successful local sign-in.
class AppAuthLoginSuccess extends AuthState {}

/// Emitted when sign-in fails (e.g. wrong store name).
class AppAuthLoginFailure extends AuthState {
  final String message;
  AppAuthLoginFailure(this.message);
}

/// Emitted after logout completes.
class AppAuthLoggedOut extends AuthState {}