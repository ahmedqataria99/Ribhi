import 'package:equatable/equatable.dart';

class BackupEntity extends Equatable {
  final String uid;
  final DateTime timestamp;
  final String filePath;

  const BackupEntity({
    required this.uid,
    required this.timestamp,
    required this.filePath,
  });

  @override
  List<Object?> get props => [uid, timestamp, filePath];
}
