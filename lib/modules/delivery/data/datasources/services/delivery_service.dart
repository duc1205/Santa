import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

part 'delivery_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v${Config.apiVersion}/deliveries")
abstract class DeliveryService {
  @factoryMethod
  factory DeliveryService(Dio dio) = _DeliveryService;

  @GET("")
  Future<List<Delivery>> getAllDeliveries(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("status") String? status,
    @Query("from_date") String? fromDate,
    @Query("to_date") String? toDate,
    @Query("q") String? query,
    @Query("cabinet_id") int? cabinetId,
    @Query("type") String? type,
  );

  @GET("/finished")
  Future<List<Delivery>> getFinishedDeliveries(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("status") String? status,
    @Query("from_date") String? fromDate,
    @Query("to_date") String? toDate,
    @Query("q") String? query,
    @Query("cabinet_id") int? cabinetId,
    @Query("type") String? type,
  );

  @GET("/unfinished")
  Future<List<Delivery>> getUnFinishedDeliveries(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("status") String? status,
    @Query("from_date") String? fromDate,
    @Query("to_date") String? toDate,
    @Query("q") String? query,
    @Query("cabinet_id") int? cabinetId,
    @Query("type") String? type,
  );

  @GET("/{delivery_id}")
  Future<Delivery> getDeliveryById(@Path("delivery_id") int deliveryId);

  @GET("/charity/id/{id}")
  Future<Delivery> getCharityDeliveryById(@Path("id") int id);

  @GET("/receivable")
  Future<List<Delivery>> getReceivableDeliveries(
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("cabinet_id") int? cabinetId,
  );

  @POST("")
  Future<Delivery> createDelivery(@Body() Map<String, dynamic> map);

  @POST("/{delivery_id}/cancel")
  Future<void> cancelDelivery(@Path("delivery_id") int deliveryId);

  @POST("/id/{delivery_id}/sent/cancel")
  Future<void> cancelSentDelivery(@Path("delivery_id") int deliveryId, @Body() Map<String, dynamic> body);

  @POST("/{delivery_id}/receive")
  Future<void> receiveDelivery(@Path("delivery_id") int deliveryId, @Body() Map<String, dynamic> map);

  @POST("/receiver/rent")
  Future<Delivery> rentPocket(@Body() Map<String, dynamic> map);

  @POST("/receiver/self-rent")
  Future<Delivery> selfRentPocket(@Body() Map<String, dynamic> map);

  @POST("/{id}/send")
  Future sendDelivery(@Path("id") int deliveryId);

  @GET("/receivers/recent")
  Future<List<User>> getRecentReceivers(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
  );

  @POST("/id/{delivery_id}/pockets/size/change")
  Future<void> changePocketSize(@Path("delivery_id") int deliveryId, @Body() Map<String, dynamic> map);

  @GET("/id/{delivery_id}/receiving/final-price/estimate")
  Future<int> getEstimateFinalReceivingPrice({
    @Path("delivery_id") int? deliveryId,
  });

  @POST("/id/{id}/reopen/check")
  Future<bool> checkDeliveryReopenable({
    @Path("id") int? deliveryId,
  });

  @POST("/id/{id}/reopen")
  Future<ReopenRequest> reopenPocket(@Path("id") int deliveryId, @Body() Map<String, dynamic> map);

  @GET("/reopen-requests/id/{id}")
  Future<ReopenRequest> getDeliveryReopenRequest(@Path("id") int reopenRequestId);

  @POST("/charities/campaigns/id/{id}/donate")
  Future<Delivery> donateForCharity(
    @Path("id") String id,
    @Body() Map<String, dynamic> map,
  );

  @GET("/charity")
  Future<List<Delivery>> getAllCharityDeliveries(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("status") String? status,
    @Query("from_date") String? fromDate,
    @Query("to_date") String? toDate,
    @Query("q") String? query,
    @Query("cabinet_id") int? cabinetId,
  );

  @GET("/charity/finished")
  Future<List<Delivery>> getFinishedCharityDeliveries(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("status") String? status,
    @Query("from_date") String? fromDate,
    @Query("to_date") String? toDate,
    @Query("q") String? query,
    @Query("cabinet_id") int? cabinetId,
  );

  @GET("/charity/unfinished")
  Future<List<Delivery>> getUnFinishedCharityDeliveries(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("status") String? status,
    @Query("from_date") String? fromDate,
    @Query("to_date") String? toDate,
    @Query("q") String? query,
    @Query("cabinet_id") int? cabinetId,
  );
}
