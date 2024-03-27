import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/setting/data/datasources/setting_remote_datasource.dart';
import 'package:santapocket/modules/setting/domain/models/setting.dart';

@lazySingleton
class SettingRepository {
  final SettingRemoteDatasource _settingRemoteDatasource;

  SettingRepository(this._settingRemoteDatasource);

  Future<Setting> getSetting(String key) => _settingRemoteDatasource.getSetting(key);

  Future<List<Setting>> getSettings() => _settingRemoteDatasource.getSettings();
}
