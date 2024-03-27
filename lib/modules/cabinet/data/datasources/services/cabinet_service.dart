import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';

part 'cabinet_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v${Config.apiVersion}/cabinets")
abstract class CabinetService {
  @factoryMethod
  factory CabinetService(Dio dio) = _CabinetService;

  @GET("/{uuid}/info")
  Future<CabinetInfo> getCabinetInfo(
    @Path("uuid") String uuid,
    @Query("otp") String? otp,
  );

  @GET("/{id}")
  Future<Cabinet> getCabinet(@Path("id") int id);

  @GET("/nearby")
  Future<List<Cabinet>> getNearBy(
    @Query("latitude") double latitude,
    @Query("longitude") double longitude,
    @Query("radius") double radius,
  );

  @GET("/{cabinet_id}/pockets/sizes")
  Future<List<PocketSize>> getPocketSizes(@Path("cabinet_id") int cabinetId);

  @GET("")
  Future<List<Cabinet>> getCabinets(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("q") String? query,
    @Query("sort_nearby") String? nearBy,
    @Query("latitude") double? latitude,
    @Query("longitude") double? longitude,
    @Query("city") String? city,
    @Query("district") String? district,
    @Query("merchant_type") String? merchantType,
  );

  @GET("/receivable-deliveries")
  Future<List<CabinetInfo>> getListCabinetInfo();

  @GET("/authorizations/receivable-deliveries")
  Future<List<CabinetInfo>> getListCabinetInfoWithAuthorizations();
}
