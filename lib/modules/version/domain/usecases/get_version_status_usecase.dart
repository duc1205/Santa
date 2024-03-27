import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/version/domain/enums/version_status.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

@lazySingleton
class GetVersionStatusUsecase {
  static const keyMinVersion = "main_app_min_version";
  static const keyDeprecatedVersion = "main_app_deprecated_version";
  static const mainAppCheckNewVersionEnabled = "main_app_check_new_version_enabled";

  VersionStatus? status;

  final GetSettingUsecase _getSettingUsecase;

  GetVersionStatusUsecase(this._getSettingUsecase);

  Future<VersionStatus> run() async {
    if (status == null || status == VersionStatus.unknown) {
      status = await _check();
    }
    return status!;
  }

  Future<VersionStatus> _check() async {
    final appVersion = Version.parse((await PackageInfo.fromPlatform()).version);

    final minVersion = await _getVersionSetting(keyMinVersion);
    if (appVersion < minVersion) {
      return VersionStatus.outdated;
    }

    final deprecatedVersion = await _getVersionSetting(keyDeprecatedVersion);
    if (appVersion <= deprecatedVersion) {
      return VersionStatus.deprecated;
    }

    final isUpdatable = (await _getSettingUsecase.run(mainAppCheckNewVersionEnabled)).value as bool?;

    if (isUpdatable ?? false) {
      await Upgrader().initialize();
      final latestVersionStr = Upgrader().currentAppStoreVersion();
      if (latestVersionStr == null) {
        return VersionStatus.unknown;
      }
      final latestVersion = Version.parse(latestVersionStr);
      return appVersion < latestVersion ? VersionStatus.updatable : VersionStatus.upToDate;
    } else {
      return VersionStatus.upToDate;
    }
  }

  Future<Version> _getVersionSetting(String key) async {
    try {
      final setting = await _getSettingUsecase.run(key);
      final value = setting.value as String?;
      return Version.parse(value ?? "0.0.0");
    } catch (error) {
      return Version.parse("0.0.0");
    }
  }
}
