import 'package:equatable/equatable.dart';

abstract class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {
  const BackupInitial();
}

class BackupLoading extends BackupState {
  const BackupLoading();
}

class BackupInProgress extends BackupState {
  final double progress;

  const BackupInProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class BackupQueued extends BackupState {
  final String message;

  const BackupQueued(this.message);

  @override
  List<Object?> get props => [message];
}

class BackupSuccess extends BackupState {
  const BackupSuccess();
}

class RestoreLoading extends BackupState {
  const RestoreLoading();
}

class RestoreInProgress extends BackupState {
  final double progress;

  const RestoreInProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class RestoreSuccess extends BackupState {}

class BackupError extends BackupState {
  final String message;

  const BackupError(this.message);

  @override
  List<Object?> get props => [message];
}
