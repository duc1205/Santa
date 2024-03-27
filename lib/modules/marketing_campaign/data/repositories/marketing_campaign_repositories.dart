import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/marketing_campaign/data/datasources/marketing_campaign_datasource.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class MarketingCampaignRepositories extends Repository {
  final MarketingCampaignDatasource _marketingCampaignDatasource;

  const MarketingCampaignRepositories(this._marketingCampaignDatasource);

  Future<List<MarketingCampaign>> getRunningMarketingCampaigns(SortParams? sortParams) =>
      _marketingCampaignDatasource.getRunningMarketingCampaigns(sortParams);

  Future<bool> clickOnCampaignBanner(int id) => _marketingCampaignDatasource.clickOnCampaignBanner(id);

  Future<bool> clickOnCampaignPopup(int id) => _marketingCampaignDatasource.clickOnCampaignPopup(id);
}
