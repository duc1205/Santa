import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

class Config {
  static const bool debug = false;
  static const String injectionEnvironment = Environment.prod;
  static const Level logLevel = Level.warning;
  static const bool aliceEnable = true;

  static const String baseUrl = "http://dev.sugamobile.com:26136";
  static const String baseSurpriseUrl = "http://santapocket-stg.w3suga.com:8282";
  static const String apiVersion = "1";
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const String oauthClientId = "2";
  static const String oauth2ClientSecret = "RGGjZkppxlKXljOvHL5nOoovAWrgqa2dfIbAUbx8";

  static const bool topupEnable = true;

  static const bool vnpaySandbox = true;
  static const String vnpayTmnCode = "SUGA0001";
  static const String vnpayDeepLink = "https://deeplink.santapocket.com/?type=vnpay";

  static const bool remoteRentEnable = false;

  static const String systemMaintenanceRemoteConfigKey = "stg_system_maintenance";

  static const String remoteImageResizeBaseUrl = "http://dev.sugamobile.com:51291";
}
