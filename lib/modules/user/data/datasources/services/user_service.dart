import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';

part 'user_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/users")
abstract class UserService {
  @factoryMethod
  factory UserService(Dio dio) = _UserService;

  @GET("/{phoneNumber}/find")
  Future<dynamic> findUserPublicInfo(@Path("phoneNumber") String phoneNumber);
}
