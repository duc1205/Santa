import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/hrm_payroll/domain/models/payroll_log.dart';

part 'hrm_payroll_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v${Config.apiVersion}/payrolls")
abstract class HrmPayrollService {
  @factoryMethod
  factory HrmPayrollService(Dio dio) = _HrmPayrollService;

  @GET("/logs")
  Future<List<PayrollLog>> getPayrollLogs({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
  });

  @POST("/activate")
  Future<void> activatePayrollAccount(@Body() Map<String, String> param);

  @POST("/deactivate")
  Future<void> deactivatePayrollAccount();

  @GET("/status")
  Future<String> checkPayrollStatus();

  @GET("/amount")
  Future<int> getPayrollAmount();
}
