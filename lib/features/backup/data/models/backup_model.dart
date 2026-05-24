import 'package:ribhi/features/backup/domain/entities/backup_entity.dart';

class BackupModel extends BackupEntity {
  const BackupModel({
    required super.uid,
    required super.timestamp,
    required super.filePath,
  });

  factory BackupModel.fromEntity(BackupEntity entity) {
    return BackupModel(
      uid: entity.uid,
      timestamp: entity.timestamp,
      filePath: entity.filePath,
    );
  }
}
