import 'package:dartz/dartz.dart';
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/backup/domain/repositories/backup_repository.dart';

class UploadBackupUseCase {
  final BackupRepository repository;

  UploadBackupUseCase(this.repository);

  Future<Either<Faliur, void>> call({void Function(double)? onProgress}) {
    return repository.uploadBackup(onProgress: onProgress);
  }
}

class RestoreBackupUseCase {
  final BackupRepository repository;

  RestoreBackupUseCase(this.repository);

  Future<Either<Faliur, void>> call({void Function(double)? onProgress}) {
    return repository.restoreBackup(onProgress: onProgress);
  }
}

class HasInternetConnectionUseCase {
  final BackupRepository repository;

  HasInternetConnectionUseCase(this.repository);

  Future<Either<Faliur, bool>> call() {
    return repository.hasInternetConnection();
  }
}

class GetDatabasePathUseCase {
  final BackupRepository repository;

  GetDatabasePathUseCase(this.repository);

  Future<Either<Faliur, String>> call() {
    return repository.getDatabasePath();
  }
}
