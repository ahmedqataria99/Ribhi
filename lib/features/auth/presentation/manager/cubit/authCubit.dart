import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/auth/data/datasource/auth_local_service.dart';
import 'package:ribhi/features/auth/domain/repositories/auth_repository.dart';
import 'package:ribhi/features/auth/presentation/manager/cubit/auth_state.dart';
import 'package:ribhi/features/Initialization/data/datasource/SettingLocalData.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final AuthLocalService authLocalService;
  final SettingsLocalDataSource settingsDataSource;

  AuthCubit({
    required this.authRepository,
    required this.authLocalService,
    required this.settingsDataSource,
  }) : super(AuthInitial());

  // ─────────────────────────────────────────────
  // 🔍 Check Email Verification
  // ─────────────────────────────────────────────
  Future<void> checkEmailVerification() async {
    emit(CheckEmailVerificationInProgress());

    final isVerified = await authRepository.isEmailVerified();

    if (isVerified) {
      emit(AuthEmailVerifiedSuccess());
    } else {
      emit(AuthEmailNotVerifiedYet());
    }
  }

  // ─────────────────────────────────────────────
  // 🚀 Check Login Status (Splash)
  // ─────────────────────────────────────────────
  Future<void> checkLoginStatus() async {
    emit(AppAuthChecking());

    final loggedIn = await authLocalService.isLoggedIn();

    if (loggedIn) {
      emit(AppAuthAuthenticated());
    } else {
      emit(AppAuthUnauthenticated());
    }
  }

  // ─────────────────────────────────────────────
  // 🔥 LOGIN باستخدام Firebase
  // ─────────────────────────────────────────────
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(AppAuthLoginFailure('Please fill in all fields.'));
      return;
    }

    emit(AppAuthLoginLoading());

    try {
      final result = await authRepository.signInUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      result.fold(
        (failure) {
          emit(AppAuthLoginFailure(failure.errmessage));
        },
        (user) async {
          // ✅ حفظ حالة الدخول
          await authLocalService.saveLoginState(storeName: email);

          emit(AppAuthLoginSuccess());
        },
      );
    } catch (e) {
      emit(AppAuthLoginFailure('Login failed. Try again.'));
    }
  }

  // ─────────────────────────────────────────────
  // 🚪 Logout
  // ─────────────────────────────────────────────
  Future<void> logout() async {
    await authLocalService.logout();
    emit(AppAuthLoggedOut());
  }

  // ─────────────────────────────────────────────
  // 💾 Save after SignUp (اختياري)
  // ─────────────────────────────────────────────
  Future<void> saveLoginAfterSignUp({
    required String email,
  }) async {
    await authLocalService.saveLoginState(storeName: email);
    emit(AppAuthLoginSuccess());
  }
}