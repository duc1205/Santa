import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCabinetsNearbyUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetCabinetsNearbyUsecase(this._cabinetRepository);

  Future<List<Cabinet>> run(double latitude, double longitude, double radius) => _cabinetRepository.getNearBy(latitude, longitude, radius);
}
