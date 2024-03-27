import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/helpers/permission_helper.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/models/user_device.dart';
import 'package:version/version.dart';

@lazySingleton
class UpdateDeviceInfoUsecase {
  final UserRepository _userRepository;

  UpdateDeviceInfoUsecase(this._userRepository);

  Future<bool> run() async {
    String appVersion = Version.parse((await PackageInfo.fromPlatform()).version).toString();
    bool notificationPermission = await PermissionHelper.instance.checkForStatus(Permission.notification);

    late final UserDevice userDevice;
    final plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      userDevice = UserDevice(
        appVersion: appVersion,
        os: 'Android',
        osVersion: info.version.release,
        deviceModel: info.model?.replaceAll(RegExp("[^a-zA-Z0-9 ]+"), ""),
        notificationPermission: notificationPermission,
      );
    } else if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      userDevice = UserDevice(
        appVersion: appVersion,
        os: 'iOS',
        osVersion: info.systemVersion,
        deviceModel: info.model?.replaceAll(RegExp("[^a-zA-Z0-9 ]+"), ""),
        notificationPermission: notificationPermission,
      );
    }
    return _userRepository.updateDeviceInfo(userDevice);
  }
}
