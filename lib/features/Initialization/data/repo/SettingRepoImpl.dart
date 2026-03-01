import 'package:ribhi/features/Initialization/data/datasource/SettingLocalData.dart';
import 'package:ribhi/features/Initialization/data/model/settingModel.dart' show SettingsModel;
import 'package:ribhi/features/Initialization/domain/entity/Settings.dart';
import 'package:ribhi/features/Initialization/domain/repo/SettingRepo.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource local;

  SettingsRepositoryImpl(this.local);

  @override
  Future<void> initialize(Settings settings) async {
    final model = SettingsModel.fromEntity(settings);
    await local.insert(model);
  }

  @override
  Future<Settings?> getSettings() async {
    final model = await local.get();
    if (model == null) return null;
    return model.toEntity();
  }

  @override
  Future<void> update(Settings settings) async {
    final model = SettingsModel.fromEntity(settings);
    await local.update(model);
  }

  @override
  Future<bool> isInitialized() async {
    final settings = await local.get();
    return settings != null;
  }
}