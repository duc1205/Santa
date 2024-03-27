import 'dart:async';
import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/retrofit/service_manager.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class UnregisterFcmTokenUsecase extends Usecase {
  const UnregisterFcmTokenUsecase();

  Future<Unit> run() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        return unit;
      }
      final param = HashMap<String, String>();
      param['token'] = token;
      unawaited(ServiceManager.instance.getFcmService().unRegisterFcm(param));
    } catch (error) {
      debugPrint(error.toString());
    }
    return unit;
  }
}
