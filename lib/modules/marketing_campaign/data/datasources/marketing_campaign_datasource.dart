import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/marketing_campaign/data/datasources/services/marketing_campaign_service.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';

abstract class MarketingCampaignDatasource {
  Future<List<MarketingCampaign>> getRunningMarketingCampaigns(SortParams? sortParams);

  Future<bool> clickOnCampaignBanner(int id);

  Future<bool> clickOnCampaignPopup(int id);
}

@LazySingleton(as: MarketingCampaignDatasource)
class MarketingCampaignDatasourceImpl extends MarketingCampaignDatasource {
  final MarketingCampaignService _marketingCampaignService;

  MarketingCampaignDatasourceImpl(this._marketingCampaignService);

  @override
  Future<List<MarketingCampaign>> getRunningMarketingCampaigns(SortParams? sortParams) => _marketingCampaignService.getRunningMarketingCampaigns(
        sortParams?.attribute,
        sortParams?.direction,
      );

  @override
  Future<bool> clickOnCampaignBanner(int id) => _marketingCampaignService.clickOnCampaignBanner(id);

  @override
  Future<bool> clickOnCampaignPopup(int id) => _marketingCampaignService.clickOnCampaignPopup(id);
}
