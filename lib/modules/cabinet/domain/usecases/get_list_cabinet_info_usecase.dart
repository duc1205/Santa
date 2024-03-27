import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetListCabinetInfoUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetListCabinetInfoUsecase(this._cabinetRepository);

  Future<List<CabinetInfo>> run() => _cabinetRepository.getListCabinetInfo();
}
