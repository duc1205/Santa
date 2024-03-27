import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';

part 'referral_campaign_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/marketing/referrals/campaigns")
abstract class ReferralCampaignService {
  @factoryMethod
  factory ReferralCampaignService(Dio dio) = _ReferralCampaignService;

  @GET("/new-user/running")
  Future<ReferralCampaign?> getRunningReferralCampaign();

  @POST("/codes/verify")
  Future<bool> verifyReferralCode(
    @Body() Map<String, dynamic> referralCode,
  );

  @POST("/new-user/check")
  Future<bool> checkIsReferralAvailable();
}
