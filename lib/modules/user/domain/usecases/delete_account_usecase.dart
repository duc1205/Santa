import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/shortcuts_manager.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/usecases/clear_user_cache_usecase.dart';
import 'package:santapocket/retrofit/service_manager.dart';
import 'package:santapocket/storage/spref.dart';

@lazySingleton
class DeleteAccountUsecase {
  final UserRepository _userRepository;
  final ClearUserCacheUsecase _clearUserCacheUsecase;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  DeleteAccountUsecase(
    this._userRepository,
    this._clearUserCacheUsecase,
    this._flutterLocalNotificationsPlugin,
  );

  Future<bool> run() async {
    final bool result = await _userRepository.deleteAccount();
    if (result) {
      await _clearUserCacheUsecase.run();
      SPref.instance.deleteAll();
      ShortcutsManager.instance.removeAllShortcut();
      await _flutterLocalNotificationsPlugin.cancelAll();
      ServiceManager.instance.reset();
    }
    return result;
  }
}
