import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';

@lazySingleton
class GetUserConeLogsUsecase {
  final UserRepository _userRepository;

  GetUserConeLogsUsecase(this._userRepository);

  Future<List<UserConeLog>> run(ListParams listParams, {int? earningFilter}) => _userRepository.getConeLogs(
        listParams,
        earningFilter: earningFilter,
      );
}
