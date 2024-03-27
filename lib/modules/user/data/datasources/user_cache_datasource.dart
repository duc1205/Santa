import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

abstract class UserCacheDatasource {
  Future<Unit> saveProfile(User user);

  Future<User?> getProfile();

  Future<Unit> removeProfile();

  Future<Unit> clear();
}

@LazySingleton(as: UserCacheDatasource)
class UseCacheDataSourceImpl extends UserCacheDatasource {
  final _profileKey = "user_profile";

  final FlutterSecureStorage _storage;

  UseCacheDataSourceImpl(this._storage);

  @override
  Future<Unit> saveProfile(User user) async {
    await _storage.write(key: _profileKey, value: jsonEncode(user.toJson()));
    return unit;
  }

  @override
  Future<User?> getProfile() async {
    final String? data = await _storage.read(key: _profileKey);
    if (data != null && data.isNotEmpty) {
      return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<Unit> removeProfile() async {
    await _storage.delete(key: _profileKey);
    return unit;
  }

  @override
  Future<Unit> clear() async {
    await removeProfile();
    return unit;
  }
}
