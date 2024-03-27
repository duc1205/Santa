import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/permission_helper.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CheckAndRequestNotificationPermissionUsecase extends Usecase {
  final GetSettingUsecase _getSettingUsecase;

  const CheckAndRequestNotificationPermissionUsecase(
    this._getSettingUsecase,
  );

  Future<Unit> run() async {
    int askingPeriodDays = ((await _getSettingUsecase.run(Constants.appNotificationPermissionDialogShowingPeriod)).value as int?) ?? 0;
    int askingMaxTimes = ((await _getSettingUsecase.run(Constants.appNotificationPermissionDialogDismissMaximum)).value as int?) ?? 0;
    final int time = (await SPref.instance.getPermissionAskTime()) ?? 1;
    final int permissionLastAsk = (await SPref.instance.getPermissionLastAsk()) ?? DateTime.now().millisecondsSinceEpoch;
    if (time > askingMaxTimes) return unit;
    if (_checkDaysPassed(permissionLastAsk, askingPeriodDays) || time == 1) {
      final bool result = await PermissionHelper.instance.checkPermission(
        Permission.notification,
        forceRequest: true,
        isFirstStartup: time == 1 ? true : false,
      );
      if (!result) {
        await SPref.instance.setPermissionAskTime(time + 1);
        await SPref.instance.setPermissionLastAsk(DateTime.now().millisecondsSinceEpoch);
      } else {
        await SPref.instance.setPermissionAskTime(1);
      }
    }
    return unit;
  }

  bool _checkDaysPassed(int millisecondsSinceEpoch, int days) {
    DateTime now = DateTime.now();
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    Duration difference = now.difference(targetDate);
    return difference.inDays >= days;
  }
}
