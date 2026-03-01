import 'package:ribhi/core/database/Appdatabase.dart';
import 'package:ribhi/features/Initialization/data/model/settingModel.dart';

abstract class SettingsLocalDataSource {
  Future<void> insert(SettingsModel model);

  Future<SettingsModel?> get();

  Future<void> update(SettingsModel model);
}

class SettingsLocalDataSourceImpl
    implements SettingsLocalDataSource {

  final AppDatabase db;

  SettingsLocalDataSourceImpl(this.db);

  @override
  Future<void> insert(SettingsModel model) async {
    await db.insert('settings', model.toMap());
  }

  @override
  Future<SettingsModel?> get() async {
    final result = await db.query('settings');

    if (result.isEmpty) return null;

    return SettingsModel.fromMap(result.first);
  }

  @override
  Future<void> update(SettingsModel model) async {
    await db.update(
      'settings',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}