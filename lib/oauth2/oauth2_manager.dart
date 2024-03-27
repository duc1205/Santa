import 'dart:async';

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/string_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/oauth2/endpoint.dart';
import 'package:santapocket/retrofit/service_manager.dart';
import 'package:santapocket/storage/spref.dart';

class Oauth2Manager {
  static final Oauth2Manager instance = Oauth2Manager._internal();

  Oauth2Manager._internal();

  final authorizationEndpoint = Uri.parse(EndPoint.baseUrl);
  final identifier = EndPoint.oauth2ClientId;
  final secret = EndPoint.oauth2ClientSecret;
  final timeRefreshBeforeExpire = 7 * 24 * 60 * 60 * 1000;

  Future<dynamic> loginPasswordGrant(String phoneNumber, String otp) {
    final completer = Completer<dynamic>();
    try {
      oauth2
          .resourceOwnerPasswordGrant(
        authorizationEndpoint,
        phoneNumber,
        otp,
        identifier: identifier,
        secret: secret,
        grantType: 'phone_verification_code',
        usernameKey: 'phone_number',
        passwordKey: 'otp_code',
      )
          .then((value) async {
        _onAuthSuccess(value.credentials.accessToken, value.credentials.refreshToken!, value.credentials.expiration!.millisecondsSinceEpoch);
        completer.complete(value.credentials.accessToken);
      }).catchError((error) {
        String errorMessage = "Login failure";
        if (error is oauth2.AuthorizationException) {
          errorMessage = error.error == "access_denied" ? LocaleKeys.shared_deactivated.trans() : LocaleKeys.shared_otp_incorrect.trans();
        }
        completer.completeError(errorMessage);
      });
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  void _onAuthSuccess(String accessToken, String refreshToken, int expiresAt) {
    SPref.instance.setAccessToken(accessToken);
    SPref.instance.saveRefreshToken(refreshToken);
    SPref.instance.setExpiresAt(expiresAt);
    ServiceManager.instance.reset();
  }

  void onRefreshTokenSuccess(String accessToken, String refreshToken, int expiresAt) => _onAuthSuccess(accessToken, refreshToken, expiresAt);

  Future<bool> refreshAccessToken(String? accessToken, String refreshToken, int expiration) async {
    oauth2.Credentials? credentials;
    if (accessToken != null) {
      credentials = oauth2.Credentials(
        accessToken,
        tokenEndpoint: authorizationEndpoint,
        refreshToken: refreshToken,
        expiration: DateTime.fromMillisecondsSinceEpoch(expiration),
      );
    }
    return credentials!.refresh(identifier: identifier, secret: secret).then((value) {
      _onAuthSuccess(value.accessToken, value.refreshToken!, int.parse(value.expiration!.millisecondsSinceEpoch.toString()));
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> checkAuth() async {
    final String? accessToken = await SPref.instance.getAccessToken();
    if (StringHelper.isNullOrEmpty(accessToken)) {
      return false;
    }
    final int? expiration = await SPref.instance.getExpiresAt();
    if (expiration != null) {
      if (DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(expiration - timeRefreshBeforeExpire))) {
        final String? refreshToken = await SPref.instance.getRefreshToken();
        if (StringHelper.isNullOrEmpty(refreshToken)) {
          return false;
        }
        return refreshAccessToken(accessToken, refreshToken!, expiration);
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
