import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/system_maintenance/data/repositories/system_maintenance_repository.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetActiveSystemMaintenanceUsecase extends Usecase {
  final SystemMaintenanceRepository _systemMaintenanceRepository;

  const GetActiveSystemMaintenanceUsecase(this._systemMaintenanceRepository);

  Future<SystemMaintenance?> run() => _systemMaintenanceRepository.getActiveSystemMaintenance();
}
