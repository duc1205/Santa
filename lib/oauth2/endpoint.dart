import 'package:santapocket/config/config.dart';

class EndPoint {
  static const String baseUrl = "${Config.baseUrl}/oauth/token";
  static const String oauth2ClientId = Config.oauthClientId;
  static const String oauth2ClientSecret = Config.oauth2ClientSecret;
}
