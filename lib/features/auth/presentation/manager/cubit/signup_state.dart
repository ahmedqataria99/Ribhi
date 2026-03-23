
part of 'signup_cubit.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupInLoading extends SignupState {}

class SignupInFailure extends SignupState {
  final String errorMessage;
  SignupInFailure({required this.errorMessage});
}

class SignupSuccess extends SignupState {
  final UserEntity user;
  SignupSuccess({required this.user});
}