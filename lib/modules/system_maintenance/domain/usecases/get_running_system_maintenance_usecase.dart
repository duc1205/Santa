import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/system_maintenance/data/repositories/system_maintenance_repository.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetRunningSystemMaintenanceUsecase extends Usecase {
  final SystemMaintenanceRepository _systemMaintenanceRepository;

  const GetRunningSystemMaintenanceUsecase(this._systemMaintenanceRepository);

  Future<SystemMaintenance?> run() => _systemMaintenanceRepository.getRunningSystemMaintenance();
}
