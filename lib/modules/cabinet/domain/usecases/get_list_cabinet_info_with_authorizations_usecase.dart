import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetListCabinetInfoWithAuthorizationsUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetListCabinetInfoWithAuthorizationsUsecase(this._cabinetRepository);

  Future<List<CabinetInfo>> run() => _cabinetRepository.getListCabinetInfoWithAuthorizations();
}
