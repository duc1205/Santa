import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/utils.dart' as utils;
import 'package:santapocket/loading.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/boarding/app/ui/splash/splash_page.dart';
import 'package:santapocket/modules/connection/app/ui/connection_page.dart';
import 'package:santapocket/modules/main/app/events/system_maintenance_config_change_event.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  final firebaseRemoteConfig = locator<FirebaseRemoteConfig>();
  await firebaseRemoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: Constants.fetchRemoteConfigTimeout),
      minimumFetchInterval: const Duration(hours: 12),
    ),
  );
  try {
    await firebaseRemoteConfig.fetchAndActivate();
  } catch (_) {} //If fail on fetching, ignore it and continue
  firebaseRemoteConfig.onConfigUpdated.listen((event) async {
    await firebaseRemoteConfig.activate();
    if (event.updatedKeys.contains(Config.systemMaintenanceRemoteConfigKey)) {
      locator<EventBus>().fire(const SystemMaintenanceConfigChangeEvent());
    }
  });
  setupEasyLoading();
  await runZonedGuarded(
    () async {
      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('vi')],
          path: 'assets/langs',
          useOnlyLangCode: true,
          fallbackLocale: const Locale('en'),
          child: const Main(),
        ),
      );
    },
    FirebaseCrashlytics.instance.recordError,
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MyAppState();
}

class _MyAppState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        themeMode: ThemeMode.light,
        title: 'SantaPocket',
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppTheme.orange,
          ),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: FlutterEasyLoading(child: child),
          );
        },
        home: LayoutBuilder(
          builder: (context, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) => utils.insertOverlay(context, const ConnectionPage()));
            return const SplashPage();
          },
        ),
      ),
    );
  }
}
