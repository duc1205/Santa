import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/marketing_campaign/data/repositories/marketing_campaign_repositories.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ClickOnCampaignPopupUsecase extends Usecase {
  final MarketingCampaignRepositories _marketingCampaignRepositories;

  const ClickOnCampaignPopupUsecase(this._marketingCampaignRepositories);

  Future<bool> run(int id) => _marketingCampaignRepositories.clickOnCampaignPopup(id);
}
