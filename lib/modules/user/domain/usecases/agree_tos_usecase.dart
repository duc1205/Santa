import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';

@lazySingleton
class AgreeTosUsecase {
  final UserRepository _userRepository;

  AgreeTosUsecase(
    this._userRepository,
  );

  Future<bool> run() => _userRepository.agreeTOS();
}
