import 'package:dartz/dartz.dart';
import 'package:ribhi/core/errors/Faliur.dart';

abstract class BackupRepository {
  Future<Either<Faliur, void>> uploadBackup({
    void Function(double)? onProgress,
  });

  Future<Either<Faliur, void>> restoreBackup({
    void Function(double)? onProgress,
  });

  Future<Either<Faliur, bool>> hasInternetConnection();

  Future<Either<Faliur, String>> getDatabasePath();
}
