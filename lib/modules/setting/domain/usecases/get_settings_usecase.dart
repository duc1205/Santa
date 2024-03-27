import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/setting/data/repositories/setting_repository.dart';
import 'package:santapocket/modules/setting/domain/models/setting.dart';

@lazySingleton
class GetSettingsUsecase {
  final SettingRepository _settingRepository;

  GetSettingsUsecase(this._settingRepository);

  Future<List<Setting>> run() => _settingRepository.getSettings();
}
