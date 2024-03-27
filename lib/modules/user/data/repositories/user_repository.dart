import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/user/data/datasources/user_cache_datasource.dart';
import 'package:santapocket/modules/user/data/datasources/user_remote_datasource.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';
import 'package:santapocket/modules/user/domain/models/user_device.dart';
import 'package:santapocket/modules/user/domain/models/user_public_info.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class UserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  final UserCacheDatasource _userCacheDataSource;

  UserRepository(this._userRemoteDatasource, this._userCacheDataSource);

  Future<User> getProfile() async {
    var user = await _userCacheDataSource.getProfile();
    if (user == null) {
      user = await _userRemoteDatasource.getProfile();
      await _userCacheDataSource.saveProfile(user);
    }
    return user;
  }

  Future<User> updateProfile({String? name, String? locale, String? type}) async {
    final user = await _userRemoteDatasource.updateProfile(name: name, locale: locale, type: type);
    await _userCacheDataSource.saveProfile(user);
    return user;
  }

  Future<Unit> logout() => _userRemoteDatasource.logout();

  Future<List<BalanceLog>> getBalanceLogs(ListParams listParams, {int? earningFilter}) =>
      _userRemoteDatasource.getBalanceLogs(listParams, earningFilter: earningFilter);

  Future<List<UserConeLog>> getConeLogs(ListParams listParams, {int? earningFilter}) =>
      _userRemoteDatasource.getConeLogs(listParams, earningFilter: earningFilter);

  Future<UserPublicInfo?> findUserPublicInfo({required String phoneNumber}) => _userRemoteDatasource.findUserPublicInfo(phoneNumber: phoneNumber);

  Future<Unit> removeProfileCache() => _userCacheDataSource.removeProfile();

  Future<Unit> clearCache() => _userCacheDataSource.clear();

  Future<Unit> completeTutorial() => _userRemoteDatasource.completeTutorial();

  Future<bool> updateDeviceInfo(UserDevice userDevice) => _userRemoteDatasource.updateDeviceInfo(userDevice);

  Future<bool> agreeTOS() => _userRemoteDatasource.agreeTOS();

  Future<bool> deleteAccount() => _userRemoteDatasource.deleteAccount();
}
