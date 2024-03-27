import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCabinetUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetCabinetUsecase(this._cabinetRepository);

  Future<Cabinet> run(int id) => _cabinetRepository.getCabinet(id);
}
