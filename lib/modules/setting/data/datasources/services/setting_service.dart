import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/setting/domain/models/setting.dart';

part 'setting_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/setting")
abstract class SettingService {
  @factoryMethod
  factory SettingService(Dio dio) => _SettingService(dio);

  @GET("")
  Future<List<Setting>> getSettings();

  @GET("/{key}")
  Future<Setting> getSetting(@Path("key") String key);
}
