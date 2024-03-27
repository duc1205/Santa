import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCabinetsUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetCabinetsUsecase(this._cabinetRepository);

  Future<List<Cabinet>> run(
    ListParams params, {
    String? query,
    String? nearBy,
    double? latitude,
    double? longitude,
    String? city,
    String? district,
    String? merchantType,
  }) =>
      _cabinetRepository.getCabinets(
        params,
        query: query,
        nearBy: nearBy,
        latitude: latitude,
        longitude: longitude,
        city: city,
        district: district,
        merchantType: merchantType,
      );
}
