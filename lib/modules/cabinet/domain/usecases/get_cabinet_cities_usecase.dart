import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCabinetCitiesUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetCabinetCitiesUsecase(this._cabinetRepository);

  Future<List<String>> run() => _cabinetRepository.getCabinetCities();
}
