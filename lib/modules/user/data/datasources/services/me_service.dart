import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';

part 'me_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/me")
abstract class MeService {
  @factoryMethod
  factory MeService(Dio dio) = _MeService;

  @GET("/profile")
  Future<User> getProfile();

  @PUT("/profile")
  Future<User> update(@Body() Map<String, dynamic> map);

  @POST("/logout")
  Future<void> logout();

  @GET("/balance/logs")
  Future<List<BalanceLog>> getBalanceLogs(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("is_earning") int? isEarning,
  );

  @GET("/cone/logs")
  Future<List<UserConeLog>> getConeLogs(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("is_earning") int? isEarning,
  );

  @POST("/tutorial/completed")
  Future<void> completeTutorial();

  @PUT("/device")
  Future<bool> updateDeviceInfo(@Body() Map<String, dynamic> map);

  @POST("/tos/agree")
  Future<bool> agreeTOS();

  @DELETE("/accounts")
  Future<bool> deleteAccount();
}
