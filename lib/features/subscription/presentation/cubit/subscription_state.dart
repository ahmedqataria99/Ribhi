import 'package:equatable/equatable.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class PaymentRequestSubmitted extends SubscriptionState {}

class LicenseActivated extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final bool isPremium;
  final String? plan;
  final DateTime? expiryDate;
  final DateTime? lastBackup;

  const SubscriptionLoaded({
    required this.isPremium,
    this.plan,
    this.expiryDate,
    this.lastBackup,
  });

  @override
  List<Object?> get props => [isPremium, plan, expiryDate, lastBackup];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

class CleanupCompleted extends SubscriptionState {}
