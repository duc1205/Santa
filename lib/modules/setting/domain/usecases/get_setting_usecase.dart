import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/setting/data/repositories/setting_repository.dart';
import 'package:santapocket/modules/setting/domain/models/setting.dart';

@lazySingleton
class GetSettingUsecase {
  final SettingRepository _settingRepository;

  GetSettingUsecase(this._settingRepository);

  Future<Setting> run(String key) => _settingRepository.getSetting(key);
}
