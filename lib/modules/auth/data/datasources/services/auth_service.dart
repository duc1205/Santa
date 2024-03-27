import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:santapocket/oauth2/endpoint.dart';

part 'auth_service.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoint.baseUrl)
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST("")
  Future<dynamic> refreshToken(@Body() Map<String, dynamic> body);
}
