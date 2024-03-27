import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/referral_campaign/data/datasources/services/referral_campaign_service.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';

abstract class ReferralCampaignRemoteDatasource {
  Future<ReferralCampaign?> getRunningReferralCampaign();

  Future<bool> verifyReferralCode(String? referralCode);

  Future<bool> checkIsReferralAvailable();
}

@LazySingleton(as: ReferralCampaignRemoteDatasource)
class MarketingCampaignDatasourceImpl extends ReferralCampaignRemoteDatasource {
  final ReferralCampaignService _referralCampaignService;

  MarketingCampaignDatasourceImpl(this._referralCampaignService);

  @override
  Future<ReferralCampaign?> getRunningReferralCampaign() => _referralCampaignService.getRunningReferralCampaign();

  @override
  Future<bool> verifyReferralCode(referralCode) => _referralCampaignService.verifyReferralCode({"referral_code": referralCode});

  @override
  Future<bool> checkIsReferralAvailable() => _referralCampaignService.checkIsReferralAvailable();
}
