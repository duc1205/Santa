import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/firebase/domain/usecases/unregister_fcm_token_usecase.dart';
import 'package:santapocket/helpers/shortcuts_manager.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/usecases/clear_user_cache_usecase.dart';
import 'package:santapocket/retrofit/service_manager.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

@lazySingleton
class LogoutUsecase extends Usecase {
  final UserRepository _userRepository;
  final UnregisterFcmTokenUsecase _unRegisterFcmTokenUsecase;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final ClearUserCacheUsecase _clearUserCacheUsecase;

  const LogoutUsecase(
    this._userRepository,
    this._unRegisterFcmTokenUsecase,
    this._flutterLocalNotificationsPlugin,
    this._clearUserCacheUsecase,
  );

  Future<Unit> run({bool force = false}) async {
    if (!force) {
      await _unRegisterFcmTokenUsecase.run();
      await _userRepository.logout();
    }
    await _clearUserCacheUsecase.run();
    SPref.instance.deleteAll();
    ShortcutsManager.instance.removeAllShortcut();
    await _flutterLocalNotificationsPlugin.cancelAll();
    ServiceManager.instance.reset();
    return unit;
  }
}
