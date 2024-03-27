import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/referral_campaign/data/repositories/referral_campaign_repositories.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetRunningReferralCampaignUsecase extends Usecase {
  final ReferralCampaignRepositories _referralCampaignRepositories;

  const GetRunningReferralCampaignUsecase(this._referralCampaignRepositories);

  Future<ReferralCampaign?> run() => _referralCampaignRepositories.getRunningReferralCampaign();
}
