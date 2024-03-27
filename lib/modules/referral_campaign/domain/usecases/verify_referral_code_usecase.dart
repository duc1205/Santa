import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/referral_campaign/data/repositories/referral_campaign_repositories.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class VerifyReferralCodeUsecase extends Usecase {
  final ReferralCampaignRepositories _referralCampaignRepositories;

  const VerifyReferralCodeUsecase(this._referralCampaignRepositories);

  Future<bool> run(User? user, String? referralCode) async {
    bool isVerified = await _referralCampaignRepositories.verifyReferralCode(referralCode);
    if (isVerified) {
      bool isReferralAvailable = await _referralCampaignRepositories.checkReferralNewUserCampaignAvailableOnRemote();
      if (!isReferralAvailable) await _referralCampaignRepositories.saveReferralNewUserCampaignAvailable(user);
    }
    return isVerified;
  }
}
