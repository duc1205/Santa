import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/referral_campaign/data/datasources/referral_campaign_cache_datasource.dart';
import 'package:santapocket/modules/referral_campaign/data/datasources/referral_campaign_remote_datasource.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ReferralCampaignRepositories extends Repository {
  final ReferralCampaignRemoteDatasource _referralCampaignRemoteDatasource;
  final ReferralCampaignCacheDatasource _referralCampaignCacheDatasource;

  const ReferralCampaignRepositories(this._referralCampaignRemoteDatasource, this._referralCampaignCacheDatasource);

  Future<Unit> saveReferralNewUserCampaignAvailable(User? user) => _referralCampaignCacheDatasource.saveReferralNewUserCampaignAvailable(user);

  Future<bool> checkReferralNewUserCampaignExistOnCache(User? user) => _referralCampaignCacheDatasource.checkReferralNewUserCampaignExist(user);

  Future<Unit> removeReferralNewUserCampaignAvailable(User? user) => _referralCampaignCacheDatasource.removeReferralNewUserCampaignAvailable(user);

  Future<ReferralCampaign?> getRunningReferralCampaign() => _referralCampaignRemoteDatasource.getRunningReferralCampaign();

  Future<bool> verifyReferralCode(String? referralCode) => _referralCampaignRemoteDatasource.verifyReferralCode(referralCode);

  Future<bool> checkReferralNewUserCampaignAvailableOnRemote() => _referralCampaignRemoteDatasource.checkIsReferralAvailable();
}
