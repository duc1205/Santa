import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/data/repositories/cabinet_repository.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCabinetInfoUsecase extends Usecase {
  final CabinetRepository _cabinetRepository;

  const GetCabinetInfoUsecase(this._cabinetRepository);

  Future<CabinetInfo> run({required String uuid, String? otp}) => _cabinetRepository.getCabinetInfo(uuid: uuid, otp: otp);
}
