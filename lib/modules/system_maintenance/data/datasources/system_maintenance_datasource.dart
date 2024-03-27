import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/system_maintenance/data/datasources/services/system_maintenance_service.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';

abstract class SystemMaintenanceDatasource {
  Future<SystemMaintenance?> getActiveSystemMaintenance();
}

@LazySingleton(as: SystemMaintenanceDatasource)
class SystemMaintenanceDatasourceImpl extends SystemMaintenanceDatasource {
  final SystemMaintenanceService _systemMaintenanceService;

  SystemMaintenanceDatasourceImpl(
    this._systemMaintenanceService,
  );

  @override
  Future<SystemMaintenance?> getActiveSystemMaintenance() => _systemMaintenanceService.getActiveSystemMaintenance();
}
