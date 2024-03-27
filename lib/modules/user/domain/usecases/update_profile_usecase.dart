import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/events/user_profile_changed_event.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/clear_user_cache_usecase.dart';

@lazySingleton
class UpdateProfileUsecase {
  final UserRepository _userRepository;
  final EventBus _eventBus;
  final ClearUserCacheUsecase _clearUserCacheUsecase;

  UpdateProfileUsecase(
    this._userRepository,
    this._eventBus,
    this._clearUserCacheUsecase,
  );

  Future<User> run({String? name, String? locale, String? type}) async {
    final user = await _userRepository.updateProfile(name: name, locale: locale, type: type);
    await _clearUserCacheUsecase.run();
    _eventBus.fire(UserProfileChangedEvent(user));
    return user;
  }
}
