import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/auth/data/datasources/services/auth_service.dart';
import 'package:santapocket/modules/auth/data/datasources/services/otp_service.dart';
import 'package:santapocket/modules/auth/domain/models/country.dart';
import 'package:santapocket/oauth2/endpoint.dart';
import 'package:suga_core/suga_core.dart';

abstract class AuthRemoteDatasource {
  Future<Unit> sendOtp({required String phoneNumber, required String locale});

  Future<Unit> sendOtpVoiceCall({required String phoneNumber, required String locale});

  Future<Unit> sendOtpZalo({required String phoneNumber, required String locale});

  Future<Unit> sendOtpEmail({required String email, required String locale});

  Future<List<Country>> getCountries();

  Future<dynamic> refreshToken(
    String refreshToken,
  );
}

@LazySingleton(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final OTPService _otpService;

  final AuthService _authService;

  AuthRemoteDatasourceImpl(
    this._otpService,
    this._authService,
  );

  @override
  Future<List<Country>> getCountries() => _otpService.getCountries();

  @override
  Future<Unit> sendOtp({required String phoneNumber, required String locale}) async {
    await _otpService.sendOtp({'phone_number': phoneNumber, 'locale': locale});
    return unit;
  }

  @override
  Future<Unit> sendOtpVoiceCall({required String phoneNumber, required String locale}) async {
    await _otpService.sendOtpVoiceCall({'phone_number': phoneNumber, 'locale': locale});
    return unit;
  }

  @override
  Future<Unit> sendOtpZalo({required String phoneNumber, required String locale}) async {
    await _otpService.sendOtpZalo({'phone_number': phoneNumber, 'locale': locale});
    return unit;
  }

  @override
  Future<Unit> sendOtpEmail({required String email, required String locale}) async {
    await _otpService.sendOtpMail({'email': email, 'locale': locale});
    return unit;
  }

  @override
  Future refreshToken(String refreshToken) => _authService.refreshToken({
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
        "client_id": EndPoint.oauth2ClientId,
        "client_secret": EndPoint.oauth2ClientSecret,
        "provider": "users",
      });
}
