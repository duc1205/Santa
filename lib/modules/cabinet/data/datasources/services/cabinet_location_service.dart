import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';

part 'cabinet_location_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v${Config.apiVersion}/locations/cabinets")
abstract class CabinetLocationService {
  @factoryMethod
  factory CabinetLocationService(Dio dio) = _CabinetLocationService;

  @GET("/cities/")
  Future<List<String>> getCabinetCities();

  @GET("/districts/")
  Future<List<String>> getCabinetDistricts(
    @Query("city") String city,
  );
}
