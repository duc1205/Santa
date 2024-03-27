import 'package:dio/dio.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/retrofit/services/fcm_service.dart';

class ServiceManager {
  static final ServiceManager instance = ServiceManager._internal();

  ServiceManager._internal();

  final _dio = locator<Dio>();

  FcmService? _fcmService;

  FcmService getFcmService() {
    _fcmService ??= FcmService(_dio);
    return _fcmService!;
  }

  void reset() {
    _fcmService = null;
  }
}
