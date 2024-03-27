import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:santapocket/config/config.dart';

part 'fcm_service.g.dart';

@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/fcm")
abstract class FcmService {
  factory FcmService(Dio dio) = _FcmService;

  @POST("/register")
  Future<void> registerFcm(@Body() Map<String, String> param);

  @POST("/unregister")
  Future<void> unRegisterFcm(@Body() Map<String, String> param);
}
