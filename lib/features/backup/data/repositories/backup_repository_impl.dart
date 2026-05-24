import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/backup/data/datasource/backup_datasource.dart';
import 'package:ribhi/features/backup/domain/repositories/backup_repository.dart';
import 'package:ribhi/features/subscription/domain/repositories/subscription_repository.dart';

class BackupRepositoryImpl implements BackupRepository {
  final BackupRemoteDataSource remoteDataSource;
  final BackupLocalDataSource localDataSource;
  final ConnectivityDataSource connectivityDataSource;
  final SubscriptionRepository subscriptionRepository;
  final FirebaseAuth auth;

  BackupRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityDataSource,
    required this.subscriptionRepository,
    required this.auth,
  });

  @override
  Future<Either<Faliur, void>> uploadBackup({
    void Function(double)? onProgress,
  }) async {
    try {
      // Check premium
      final premiumResult = await subscriptionRepository.isPremiumUser();
      if (premiumResult.isLeft()) return premiumResult;
      if (!premiumResult.getOrElse(() => false)) {
        return Left(Faliur(errmessage: 'Premium subscription required'));
      }

      // Check internet
      final hasInternet = await connectivityDataSource.hasInternetConnection();
      if (!hasInternet) {
        return Left(Faliur(errmessage: 'No internet connection'));
      }

      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Left(Faliur(errmessage: 'User not authenticated'));
      }
      final dbPath = await localDataSource.getDatabasePath();
      final fingerprint = await localDataSource.getDatabaseFingerprint(dbPath);
      final cachedFingerprint = await localDataSource
          .getSavedDatabaseFingerprint();

      if (cachedFingerprint != null && cachedFingerprint == fingerprint) {
        return const Right(null);
      }

      final tempPath = await localDataSource.createTempCopy(dbPath);
      final timestamp = DateTime.now();
      final fileName =
          'backup_${timestamp.year}_${timestamp.month}_${timestamp.day}.db';
      final remotePath = 'backups/$uid/$fileName';

      await _uploadWithRetry(
        localPath: tempPath,
        remotePath: remotePath,
        onProgress: onProgress,
      );

      // Update last backup and fingerprint
      await subscriptionRepository.updateLastBackup(timestamp);
      await localDataSource.saveDatabaseFingerprint(fingerprint);

      // Clean up temp file
      await File(tempPath).delete();

      return const Right(null);
    } catch (e) {
      return Left(Faliur(errmessage: 'Backup failed: ${e.toString()}'));
    }
  }

  Future<void> _uploadWithRetry({
    required String localPath,
    required String remotePath,
    void Function(double)? onProgress,
  }) async {
    const attempts = 3;
    for (var attempt = 1; attempt <= attempts; attempt++) {
      try {
        await remoteDataSource.uploadFile(
          localPath,
          remotePath,
          onProgress: onProgress,
        );
        return;
      } catch (e) {
        if (attempt == attempts) rethrow;
        await Future.delayed(Duration(seconds: 1 + attempt));
      }
    }
  }

  @override
  Future<Either<Faliur, void>> restoreBackup({
    void Function(double)? onProgress,
  }) async {
    String? tempCurrentDb;
    try {
      // Check premium
      final premiumResult = await subscriptionRepository.isPremiumUser();
      if (premiumResult.isLeft()) return premiumResult;
      if (!premiumResult.getOrElse(() => false)) {
        return Left(Faliur(errmessage: 'Premium subscription required'));
      }

      // Check internet
      final hasInternet = await connectivityDataSource.hasInternetConnection();
      if (!hasInternet) {
        return Left(Faliur(errmessage: 'No internet connection'));
      }

      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Left(Faliur(errmessage: 'User not authenticated'));
      }
      final dbPath = await localDataSource.getDatabasePath();
      tempCurrentDb = await localDataSource.createTempCopy(
        dbPath,
        name: 'current_db_backup.db',
      );

      final backupDir = 'backups/$uid';
      final backupFiles = await remoteDataSource.listFiles(backupDir);
      if (backupFiles.isEmpty) {
        return Left(Faliur(errmessage: 'No backup found'));
      }

      DateTime? parseBackupDate(String fullPath) {
        final fileName = path.basename(fullPath);
        final match = RegExp(
          r'backup_(\d{4})_(\d{1,2})_(\d{1,2})\.db',
        ).firstMatch(fileName);
        if (match == null) return null;
        final year = int.tryParse(match.group(1)!);
        final month = int.tryParse(match.group(2)!);
        final day = int.tryParse(match.group(3)!);
        if (year == null || month == null || day == null) return null;
        return DateTime(year, month, day);
      }

      final datedBackups = backupFiles
          .where(
            (remotePath) =>
                remotePath.contains('backup_') && remotePath.endsWith('.db'),
          )
          .map((remotePath) {
            final date = parseBackupDate(remotePath);
            return MapEntry(remotePath, date);
          })
          .where((entry) => entry.value != null)
          .toList();

      if (datedBackups.isEmpty) {
        return Left(Faliur(errmessage: 'No backup found'));
      }

      datedBackups.sort((a, b) => b.value!.compareTo(a.value!));
      final remotePath = datedBackups.first.key;
      final tempDir = await Directory.systemTemp.createTemp();
      final tempPath = path.join(tempDir.path, 'restore_temp.db');

      onProgress?.call(0.0);
      await remoteDataSource.downloadFile(remotePath, tempPath);
      final restoreFile = File(tempPath);
      if (!await restoreFile.exists() || await restoreFile.length() == 0) {
        throw Exception('Downloaded backup content is invalid');
      }
      onProgress?.call(1.0);

      await localDataSource.replaceDatabase(tempPath, dbPath);

      await restoreFile.delete();
      await tempDir.delete(recursive: true);
      if (tempCurrentDb != null) {
        await File(tempCurrentDb).delete();
      }

      return const Right(null);
    } catch (e) {
      if (tempCurrentDb != null) {
        try {
          final dbPath = await localDataSource.getDatabasePath();
          await localDataSource.replaceDatabase(tempCurrentDb, dbPath);
        } catch (_) {
          // If rollback also fails, preserve the original error.
        }
      }
      return Left(Faliur(errmessage: 'Restore failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Faliur, bool>> hasInternetConnection() async {
    try {
      final hasInternet = await connectivityDataSource.hasInternetConnection();
      return Right(hasInternet);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Connectivity check failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Faliur, String>> getDatabasePath() async {
    try {
      final path = await localDataSource.getDatabasePath();
      return Right(path);
    } catch (e) {
      return Left(
        Faliur(errmessage: 'Failed to get database path: ${e.toString()}'),
      );
    }
  }
}
