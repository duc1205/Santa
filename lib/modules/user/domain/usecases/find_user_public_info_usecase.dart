import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/models/user_public_info.dart';

@lazySingleton
class FindUserPublicInfoUsecase {
  final UserRepository _userRepository;

  FindUserPublicInfoUsecase(this._userRepository);

  Future<UserPublicInfo?> run({required String phoneNumber}) => _userRepository.findUserPublicInfo(phoneNumber: phoneNumber);
}
