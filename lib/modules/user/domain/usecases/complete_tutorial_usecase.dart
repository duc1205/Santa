import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/usecases/clear_user_cache_usecase.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CompleteTutorialUsecase {
  final UserRepository _userRepository;
  final ClearUserCacheUsecase _clearUserCacheUsecase;

  CompleteTutorialUsecase(
    this._userRepository,
    this._clearUserCacheUsecase,
  );

  Future<Unit> run() async {
    await _userRepository.completeTutorial();
    await _clearUserCacheUsecase.run();
    return unit;
  }
}
