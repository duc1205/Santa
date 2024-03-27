import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';

part 'system_maintenance_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/system/maintenances")
abstract class SystemMaintenanceService {
  @factoryMethod
  factory SystemMaintenanceService(Dio dio) = _SystemMaintenanceService;

  @GET("/active")
  Future<SystemMaintenance?> getActiveSystemMaintenance();
}
