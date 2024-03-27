import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/referral_campaign/data/repositories/referral_campaign_repositories.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CheckReferralCodeUsecase extends Usecase {
  final ReferralCampaignRepositories _referralCampaignRepositories;

  const CheckReferralCodeUsecase(this._referralCampaignRepositories);

  Future<bool> run(User? user) async {
    bool checkReferralAvaibleOnCache = await _referralCampaignRepositories.checkReferralNewUserCampaignExistOnCache(user);
    if (checkReferralAvaibleOnCache) {
      return false;
    }

    bool isReferralAvailable = await _referralCampaignRepositories.checkReferralNewUserCampaignAvailableOnRemote();
    if (!isReferralAvailable) {
      await _referralCampaignRepositories.saveReferralNewUserCampaignAvailable(user);
    }
    return isReferralAvailable;
  }
}
