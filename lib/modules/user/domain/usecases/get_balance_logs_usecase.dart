import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';

@lazySingleton
class GetBalanceLogsUsecase {
  final UserRepository _userRepository;

  GetBalanceLogsUsecase(this._userRepository);

  Future<List<BalanceLog>> run(ListParams listParams, {int? earningFilter}) => _userRepository.getBalanceLogs(
        listParams,
        earningFilter: earningFilter,
      );
}
