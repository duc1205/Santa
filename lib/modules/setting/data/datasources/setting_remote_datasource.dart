import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/setting/data/datasources/services/setting_service.dart';
import 'package:santapocket/modules/setting/domain/models/setting.dart';

abstract class SettingRemoteDatasource {
  Future<List<Setting>> getSettings();

  Future<Setting> getSetting(String key);
}

@LazySingleton(as: SettingRemoteDatasource)
class SettingRemoteDatasourceImpl extends SettingRemoteDatasource {
  final SettingService _settingService;

  SettingRemoteDatasourceImpl(this._settingService);

  @override
  Future<Setting> getSetting(String key) => _settingService.getSetting(key);

  @override
  Future<List<Setting>> getSettings() => _settingService.getSettings();
}
