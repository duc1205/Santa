import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/auth/domain/models/country.dart';

part 'otp_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v1")
abstract class OTPService {
  @factoryMethod
  factory OTPService(Dio dio) = _OTPService;

  @POST("/otp")
  Future<void> sendOtp(@Body() Map<String, String> param);

  @POST("/otp/voice-call")
  Future<void> sendOtpVoiceCall(@Body() Map<String, String> param);

  @POST("/otp/zns")
  Future<void> sendOtpZalo(@Body() Map<String, String> param);

  @POST("/otp/mail")
  Future<void> sendOtpMail(@Body() Map<String, String> param);

  @GET("/countries")
  Future<List<Country>> getCountries();
}
