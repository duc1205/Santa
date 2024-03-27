import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';

part 'delivery_authorization_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/deliveries/authorizations")
abstract class DeliveryAuthorizationService {
  @factoryMethod
  factory DeliveryAuthorizationService(Dio dio) = _DeliveryAuthorizationService;

  @GET("")
  Future<List<DeliveryAuthorization>> getDeliveryAuthorizations();

  @POST("")
  Future<DeliveryAuthorization> createDeliveryAuthorization(@Body() Map<String, dynamic> body);

  @GET("/{id}")
  Future<DeliveryAuthorization> getDeliveryAuthorization(@Path("id") int id);

  @POST("/{id}/receive")
  Future<DeliveryAuthorization> receiveDeliveryAuthorization(@Path("id") int id);

  @GET("/receivable")
  Future<List<DeliveryAuthorization>> getReceivableDeliveryAuthorizations(
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("cabinet_id") int? cabinetId,
  );

  @POST("/{id}/receiver/notify")
  Future notifyDeliveryAuthorizationReceiver(@Path("id") int id);

  @POST("/id/{id}/cancel")
  Future<bool> cancelDeliveryAuthorization(@Path("id") int id);
}
