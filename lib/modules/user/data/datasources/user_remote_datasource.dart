import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/user/data/datasources/services/me_service.dart';
import 'package:santapocket/modules/user/data/datasources/services/user_service.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';
import 'package:santapocket/modules/user/domain/models/user_device.dart';
import 'package:santapocket/modules/user/domain/models/user_public_info.dart';
import 'package:suga_core/suga_core.dart';

abstract class UserRemoteDatasource {
  Future<User> getProfile();

  Future<User> updateProfile({String? name, String? locale, String? type});

  Future<Unit> logout();

  Future<List<BalanceLog>> getBalanceLogs(ListParams listParams, {int? earningFilter});

  Future<List<UserConeLog>> getConeLogs(ListParams listParams, {int? earningFilter});

  Future<UserPublicInfo?> findUserPublicInfo({required String phoneNumber});

  Future<Unit> completeTutorial();

  Future<bool> updateDeviceInfo(UserDevice userDevice);

  Future<bool> agreeTOS();

  Future<bool> deleteAccount();
}

@LazySingleton(as: UserRemoteDatasource)
class UserRemoteDatasourceImpl extends UserRemoteDatasource {
  final MeService _meService;
  final UserService _userService;

  UserRemoteDatasourceImpl(this._meService, this._userService);

  @override
  Future<User> getProfile() => _meService.getProfile();

  @override
  Future<User> updateProfile({String? name, String? locale, String? type}) async {
    return _meService.update({'name': name, 'locale': locale, 'type': type});
  }

  @override
  Future<Unit> logout() async {
    await _meService.logout();
    return unit;
  }

  @override
  Future<Unit> completeTutorial() async {
    await _meService.completeTutorial();
    return unit;
  }

  @override
  Future<List<BalanceLog>> getBalanceLogs(ListParams listParams, {int? earningFilter}) {
    return _meService.getBalanceLogs(
      listParams.paginationParams?.page,
      listParams.paginationParams?.limit,
      listParams.sortParams?.attribute,
      listParams.sortParams?.direction,
      earningFilter,
    );
  }

  @override
  Future<List<UserConeLog>> getConeLogs(ListParams listParams, {int? earningFilter}) {
    return _meService.getConeLogs(
      listParams.paginationParams?.page,
      listParams.paginationParams?.limit,
      listParams.sortParams?.attribute,
      listParams.sortParams?.direction,
      earningFilter,
    );
  }

  @override
  Future<UserPublicInfo?> findUserPublicInfo({required String phoneNumber}) async {
    final data = await _userService.findUserPublicInfo(phoneNumber);
    return data == null ? null : UserPublicInfo.fromJson(data! as Map<String, dynamic>);
  }

  @override
  Future<bool> updateDeviceInfo(UserDevice userDevice) async {
    return _meService.updateDeviceInfo(userDevice.toJson());
  }

  @override
  Future<bool> agreeTOS() async {
    return _meService.agreeTOS();
  }

  @override
  Future<bool> deleteAccount() {
    return _meService.deleteAccount();
  }
}
