import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/backup/domain/usecase/backup_usecases.dart';
import 'package:ribhi/features/backup/presentation/cubit/backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  final UploadBackupUseCase uploadBackupUseCase;
  final RestoreBackupUseCase restoreBackupUseCase;
  final HasInternetConnectionUseCase hasInternetConnectionUseCase;
  bool _operationInProgress = false;

  BackupCubit({
    required this.uploadBackupUseCase,
    required this.restoreBackupUseCase,
    required this.hasInternetConnectionUseCase,
  }) : super(BackupInitial());

  Future<void> uploadBackup() async {
    if (_operationInProgress) {
      emit(BackupQueued('A backup or restore is already in progress.'));
      return;
    }

    _operationInProgress = true;
    emit(BackupInProgress(0.0));

    final result = await uploadBackupUseCase(
      onProgress: (progress) {
        emit(BackupInProgress(progress));
      },
    );

    result.fold(
      (failure) => emit(BackupError(failure.errmessage)),
      (_) => emit(BackupSuccess()),
    );

    _operationInProgress = false;
  }

  Future<void> restoreBackup() async {
    if (_operationInProgress) {
      emit(BackupQueued('A backup or restore is already in progress.'));
      return;
    }

    _operationInProgress = true;
    emit(RestoreLoading());

    final result = await restoreBackupUseCase(
      onProgress: (progress) {
        emit(RestoreInProgress(progress));
      },
    );

    result.fold(
      (failure) => emit(BackupError(failure.errmessage)),
      (_) => emit(RestoreSuccess()),
    );

    _operationInProgress = false;
  }

  Future<bool> checkInternetConnection() async {
    final result = await hasInternetConnectionUseCase();
    return result.getOrElse(() => false);
  }
}
