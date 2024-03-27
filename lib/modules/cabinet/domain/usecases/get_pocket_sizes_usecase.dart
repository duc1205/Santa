import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetPocketSizesUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetPocketSizesUsecase(this._cabinetRepository);

  Future<List<PocketSize>> run(int cabinetId) => _cabinetRepository.getPocketSizes(cabinetId);
}
