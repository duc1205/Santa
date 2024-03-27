import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ClearUserCacheUsecase {
  final UserRepository _userRepository;

  ClearUserCacheUsecase(this._userRepository);

  Future<Unit> run() => _userRepository.clearCache();
}
