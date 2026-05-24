import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ribhi/core/database/DatabaseHelper.dart';

abstract class BackupRemoteDataSource {
  Future<void> uploadFile(
    String localPath,
    String remotePath, {
    void Function(double)? onProgress,
  });

  Future<void> downloadFile(String remotePath, String localPath);

  Future<bool> fileExists(String remotePath);

  Future<List<String>> listFiles(String remoteDirectory);
}

class BackupRemoteDataSourceImpl implements BackupRemoteDataSource {
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  BackupRemoteDataSourceImpl({required this.storage, required this.auth});

  @override
  Future<void> uploadFile(
    String localPath,
    String remotePath, {
    void Function(double)? onProgress,
  }) async {
    final ref = storage.ref().child(remotePath);
    final uploadTask = ref.putFile(File(localPath));
    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snapshot) {
        final totalBytes = snapshot.totalBytes;
        final transferredBytes = snapshot.bytesTransferred;
        if (totalBytes > 0) {
          onProgress(transferredBytes / totalBytes);
        }
      });
    }
    await uploadTask;
  }

  @override
  Future<void> downloadFile(String remotePath, String localPath) async {
    final ref = storage.ref().child(remotePath);
    final file = File(localPath);
    await ref.writeToFile(file);
  }

  @override
  Future<bool> fileExists(String remotePath) async {
    final ref = storage.ref().child(remotePath);
    try {
      await ref.getMetadata();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<String>> listFiles(String remoteDirectory) async {
    final ref = storage.ref().child(remoteDirectory);
    final listResult = await ref.listAll();
    return listResult.items.map((item) => item.fullPath).toList();
  }
}

class BackupLocalDataSource {
  final DatabaseHelper dbHelper;

  BackupLocalDataSource(this.dbHelper);

  Future<String> getDatabasePath() async {
    return await dbHelper.getDatabasePath();
  }

  Future<String> createTempCopy(
    String dbPath, {
    String name = 'backup_temp.db',
  }) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = path.join(tempDir.path, name);
    await File(dbPath).copy(tempPath);
    return tempPath;
  }

  Future<String> getDatabaseFingerprint(String dbPath) async {
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      throw Exception('Database file not found');
    }
    final stat = await dbFile.stat();
    return '${stat.size}:${stat.modified.millisecondsSinceEpoch}';
  }

  Future<File> _fingerprintFile() async {
    final tempDir = await getTemporaryDirectory();
    return File(path.join(tempDir.path, 'backup_fingerprint.txt'));
  }

  Future<String?> getSavedDatabaseFingerprint() async {
    final file = await _fingerprintFile();
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  Future<void> saveDatabaseFingerprint(String fingerprint) async {
    final file = await _fingerprintFile();
    await file.writeAsString(fingerprint);
  }

  Future<void> replaceDatabase(String tempPath, String dbPath) async {
    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    await File(tempPath).copy(dbPath);
  }
}

class ConnectivityDataSource {
  final Connectivity connectivity;

  ConnectivityDataSource(this.connectivity);

  Future<bool> hasInternetConnection() async {
    final dynamic result = await connectivity.checkConnectivity();
    if (result is List<ConnectivityResult>) {
      return result.isNotEmpty && result.first != ConnectivityResult.none;
    }
    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }
    return false;
  }
}
