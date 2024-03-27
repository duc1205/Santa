import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/firebase/fcm_manager.dart';
import 'package:santapocket/locator.config.dart';
import 'package:santapocket/retrofit/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

final locator = GetIt.instance;

@injectableInit
Future<Unit> setupLocator() async {
  await $initGetIt(locator, environment: Config.injectionEnvironment);
  return unit;
}

@module
abstract class Locator {
  @lazySingleton
  @preResolve
  Future<SharedPreferences> getSharePreferences() async => SharedPreferences.getInstance();

  @lazySingleton
  Logger getLogger() => Logger(level: Config.logLevel);

  @lazySingleton
  RouteObserver<Route> getRouteObserver() => RouteObserver();

  @lazySingleton
  EventBus getEventBus() => EventBus();

  @lazySingleton
  Dio getDio() => locator<RestClient>().dio;

  @lazySingleton
  FlutterSecureStorage getStorage() => const FlutterSecureStorage();

  @lazySingleton
  FlutterLocalNotificationsPlugin getFlutterNotificationPlugin() => FlutterLocalNotificationsPlugin();

  @lazySingleton
  FCMManager getFcmManager() => FCMManager();

  @lazySingleton
  Alice getAlice() => Alice(
        navigatorKey: Get.key,
      );

  @lazySingleton
  FirebaseRemoteConfig getFirebaseRemoteConfig() => FirebaseRemoteConfig.instance;
}
