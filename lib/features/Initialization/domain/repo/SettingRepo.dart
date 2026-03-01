import 'package:ribhi/features/Initialization/domain/entity/Settings.dart';

abstract class SettingsRepository {
  Future<void> initialize(Settings settings);

  Future<Settings?> getSettings();

  Future<void> update(Settings settings);

  Future<bool> isInitialized();
}