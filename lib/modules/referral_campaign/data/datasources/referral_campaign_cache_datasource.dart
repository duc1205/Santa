import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

abstract class ReferralCampaignCacheDatasource {
  Future<Unit> saveReferralNewUserCampaignAvailable(User? user);

  Future<bool> checkReferralNewUserCampaignExist(User? user);

  Future<Unit> removeReferralNewUserCampaignAvailable(User? user);
}

@LazySingleton(as: ReferralCampaignCacheDatasource)
class ReferralCacheDataSourceImpl extends ReferralCampaignCacheDatasource {
  final FlutterSecureStorage _storage;

  ReferralCacheDataSourceImpl(this._storage);

  @override
  Future<Unit> saveReferralNewUserCampaignAvailable(User? user) async {
    await _storage.write(key: "referral_new_user_campaign_available_${user?.id}", value: jsonEncode(false));
    return unit;
  }

  @override
  Future<bool> checkReferralNewUserCampaignExist(User? user) async {
    return _storage.containsKey(key: "referral_new_user_campaign_available_${user?.id}");
  }

  @override
  Future<Unit> removeReferralNewUserCampaignAvailable(User? user) async {
    await _storage.delete(key: "referral_new_user_campaign_available_${user?.id}");
    return unit;
  }
}
