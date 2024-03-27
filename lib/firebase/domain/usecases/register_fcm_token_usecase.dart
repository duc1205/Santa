import 'dart:collection';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/retrofit/service_manager.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class RegisterFcmTokenUsecase extends Usecase {
  const RegisterFcmTokenUsecase();

  Future<Unit> run() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      return unit;
    } else {
      final platform = Platform.operatingSystem;
      final params = HashMap<String, String>();
      params['platform'] = platform;
      params['token'] = token;
      await ServiceManager.instance.getFcmService().registerFcm(params);
    }
    return unit;
  }
}
