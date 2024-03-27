import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

@lazySingleton
class GetProfileUsecase {
  final UserRepository _userRepository;

  GetProfileUsecase(this._userRepository);

  Future<User> run() => _userRepository.getProfile();
}
