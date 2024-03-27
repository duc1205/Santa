import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCabinetDistrictsUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetCabinetDistrictsUsecase(this._cabinetRepository);

  Future<List<String>> run({required String city}) => _cabinetRepository.getCabinetDistricts(city);
}
