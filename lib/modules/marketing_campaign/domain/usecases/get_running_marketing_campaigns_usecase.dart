import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/marketing_campaign/data/repositories/marketing_campaign_repositories.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetRunningMarketingCampaignsUsecase extends Usecase {
  final MarketingCampaignRepositories _marketingCampaignRepositories;

  const GetRunningMarketingCampaignsUsecase(this._marketingCampaignRepositories);

  Future<List<MarketingCampaign>> run(SortParams? sortParams) => _marketingCampaignRepositories.getRunningMarketingCampaigns(sortParams);
}
