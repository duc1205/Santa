import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/auth/data/datasources/auth_remote_datasource.dart';
import 'package:santapocket/modules/auth/domain/models/country.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class AuthRepository extends Repository {
  final AuthRemoteDatasource _authRemoteDatasource;

  const AuthRepository(this._authRemoteDatasource);

  Future<List<Country>> getCountries() => _authRemoteDatasource.getCountries();

  Future<Unit> sendOtp({required String phoneNumber, required String locale}) =>
      _authRemoteDatasource.sendOtp(phoneNumber: phoneNumber, locale: locale);

  Future<Unit> sendOtpVoiceCall({required String phoneNumber, required String locale}) =>
      _authRemoteDatasource.sendOtpVoiceCall(phoneNumber: phoneNumber, locale: locale);

  Future<Unit> sendOtpZalo({required String phoneNumber, required String locale}) =>
      _authRemoteDatasource.sendOtpZalo(phoneNumber: phoneNumber, locale: locale);

  Future<Unit> sendOtpEmail({required String email, required String locale}) => _authRemoteDatasource.sendOtpEmail(email: email, locale: locale);

  Future<dynamic> refreshToken(String refreshToken) => _authRemoteDatasource.refreshToken(refreshToken);
}
