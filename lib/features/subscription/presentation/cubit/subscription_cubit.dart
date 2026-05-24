import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/subscription/domain/usecase/subscription_usecases.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubmitPaymentRequestUseCase submitPaymentRequestUseCase;
  final ActivateLicenseKeyUseCase activateLicenseKeyUseCase;
  final GetUserSubscriptionUseCase getUserSubscriptionUseCase;
  final IsPremiumUserUseCase isPremiumUserUseCase;
  final UpdateLastBackupUseCase updateLastBackupUseCase;
  final CleanupOldPaymentRequestsUseCase cleanupOldPaymentRequestsUseCase;
  Timer? _refreshTimer;

  SubscriptionCubit({
    required this.submitPaymentRequestUseCase,
    required this.activateLicenseKeyUseCase,
    required this.getUserSubscriptionUseCase,
    required this.isPremiumUserUseCase,
    required this.updateLastBackupUseCase,
    required this.cleanupOldPaymentRequestsUseCase,
  }) : super(SubscriptionInitial()) {
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => refreshSubscriptionStatus(),
    );
  }

  Future<void> submitPaymentRequest({
    required String phone,
    required String transactionId,
  }) async {
    emit(SubscriptionLoading());
    final result = await submitPaymentRequestUseCase(
      phone: phone,
      transactionId: transactionId,
    );
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (_) => emit(PaymentRequestSubmitted()),
    );
  }

  Future<void> activateLicenseKey(String key) async {
    emit(SubscriptionLoading());
    final result = await activateLicenseKeyUseCase(key);
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (_) => emit(LicenseActivated()),
    );
  }

  Future<void> loadSubscriptionStatus() async {
    emit(SubscriptionLoading());
    final result = await getUserSubscriptionUseCase();
    result.fold((failure) => emit(SubscriptionError(failure.message)), (
      subscription,
    ) {
      final isPremium =
          subscription != null &&
          subscription.active &&
          subscription.expiryDate.isAfter(DateTime.now());
      return emit(
        SubscriptionLoaded(
          isPremium: isPremium,
          plan: subscription?.plan,
          expiryDate: subscription?.expiryDate,
          lastBackup: subscription?.lastBackup,
        ),
      );
    });
  }

  Future<void> refreshSubscriptionStatus() async {
    final result = await getUserSubscriptionUseCase();
    result.fold(
      (failure) {
        emit(SubscriptionError(failure.message));
      },
      (subscription) {
        final isPremium =
            subscription != null &&
            subscription.active &&
            subscription.expiryDate.isAfter(DateTime.now());
        final updatedState = SubscriptionLoaded(
          isPremium: isPremium,
          plan: subscription?.plan,
          expiryDate: subscription?.expiryDate,
          lastBackup: subscription?.lastBackup,
        );
        if (state != updatedState) {
          emit(updatedState);
        }
      },
    );
  }

  Future<void> checkPremiumStatus() async {
    final result = await isPremiumUserUseCase();
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (isPremium) => emit(
        SubscriptionLoaded(
          isPremium: isPremium,
          // Keep other fields if already loaded
          plan: state is SubscriptionLoaded
              ? (state as SubscriptionLoaded).plan
              : null,
          expiryDate: state is SubscriptionLoaded
              ? (state as SubscriptionLoaded).expiryDate
              : null,
          lastBackup: state is SubscriptionLoaded
              ? (state as SubscriptionLoaded).lastBackup
              : null,
        ),
      ),
    );
  }

  Future<bool> isUserPremium() async {
    final result = await isPremiumUserUseCase();
    return result.getOrElse(() => false);
  }

  Future<void> cleanupOldPaymentRequests(int daysOld) async {
    emit(SubscriptionLoading());
    final result = await cleanupOldPaymentRequestsUseCase(daysOld);
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (_) => emit(CleanupCompleted()),
    );
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
