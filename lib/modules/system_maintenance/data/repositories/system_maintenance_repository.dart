import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/system_maintenance/data/datasources/system_maintenance_datasource.dart';
import 'package:santapocket/modules/system_maintenance/data/datasources/system_maintenance_firebase_datasource.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SystemMaintenanceRepository extends Repository {
  final SystemMaintenanceDatasource _systemMaintenanceDatasource;
  final SystemMaintenanceFirebaseDatasource _systemMaintenanceFirebaseConfigDatasource;

  const SystemMaintenanceRepository(
    this._systemMaintenanceDatasource,
    this._systemMaintenanceFirebaseConfigDatasource,
  );

  Future<SystemMaintenance?> getActiveSystemMaintenance() => _systemMaintenanceDatasource.getActiveSystemMaintenance();

  Future<SystemMaintenance?> getRunningSystemMaintenance() => _systemMaintenanceFirebaseConfigDatasource.getRunningSystemMaintenance();
}
