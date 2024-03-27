import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';

part 'marketing_campaign_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}//api/client/v1/marketing/campaigns")
abstract class MarketingCampaignService {
  @factoryMethod
  factory MarketingCampaignService(Dio dio) = _MarketingCampaignService;

  @GET("")
  Future<List<MarketingCampaign>> getRunningMarketingCampaigns(
    @Query("sort") String? sort,
    @Query("dir") String? dir,
  );

  @POST("/id/{id}/banner/click")
  Future<bool> clickOnCampaignBanner(@Path("id") int id);

  @POST("/id/{id}/popup/click")
  Future<bool> clickOnCampaignPopup(@Path("id") int id);
}
