import 'dart:io';

import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/events/session_expired_event.dart';
import 'package:santapocket/modules/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/logout_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:shake/shake.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class RestClient {
  static final BaseOptions _options = BaseOptions(
    baseUrl: Config.baseUrl,
    connectTimeout: Config.connectTimeout,
    receiveTimeout: Config.receiveTimeout,
  );

  Dio dio = Dio(_options);

  bool onRefreshToken = false;

  Future<Unit> _configDioInterceptors() async {
    final developerModeEnable = await SPref.instance.getDeveloperModeEnable();
    if (Config.aliceEnable || developerModeEnable) {
      dio.interceptors.add(locator<Alice>().getDioInterceptor());
      ShakeDetector.autoStart(onPhoneShake: () {
        locator<Alice>().showInspector();
      });
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SPref.instance.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          options.headers["Accept"] = "application/json";
          options.headers["X-Language"] = await SPref.instance.getLanguage() ?? Platform.localeName.substring(0, 2);
          handler.next(options);
        },
        onResponse: (e, handler) async {
          if (e.data is Map<String, dynamic>) {
            final data = e.data as Map<String, dynamic>;
            if (data.containsKey("data") && data.containsKey("meta")) {
              e.data = data["data"];
            }
          }
          handler.next(e);
        },
        onError: (DioError e, handler) async {
          switch (e.type) {
            case DioErrorType.connectTimeout:
            case DioErrorType.sendTimeout:
            case DioErrorType.receiveTimeout:
              return handler.next(RestError.fromErrorString(LocaleKeys.shared_network_problem.trans(), null));
            case DioErrorType.response:
              if (e.response != null) {
                if (e.response!.statusCode == HttpStatus.unauthorized) {
                  if (!onRefreshToken) {
                    onRefreshToken = true;
                    await locator<RefreshTokenUsecase>().run();
                  } else {
                    onRefreshToken = false;
                    await locator<LogoutUsecase>().run(force: true);
                    locator<EventBus>().fire(const SessionExpiredEvent());
                  }
                }
                if (e.response!.statusCode == HttpStatus.tooManyRequests) {
                  return handler.next(RestError.fromErrorString("Too many requests", e.response!.headers));
                }
                if (e.response!.data != null) {
                  return handler.next(RestError.fromJson(e.response!.data, e.response!.headers));
                }
                return handler.next(RestError.fromErrorString(e.message, e.response!.headers));
              }
              return handler.next(RestError.fromErrorString(e.message, null));
            case DioErrorType.other:
              if (e.message.contains('SocketException')) {
                return handler.next(RestError.fromErrorString(LocaleKeys.shared_network_problem.trans(), null));
              }
              return handler.next(RestError.fromErrorString(LocaleKeys.shared_problem_connecting_server.trans(), null));
            case DioErrorType.cancel:
            default:
              return handler.next(RestError.fromErrorString(LocaleKeys.shared_problem_connecting_server.trans(), null));
          }
        },
      ),
    );
    return unit;
  }

  RestClient() {
    _configDioInterceptors();
  }
}
