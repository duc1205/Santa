import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign_image.dart';
import 'package:santapocket/modules/charity/domain/models/charity_donation.dart';
import 'package:santapocket/modules/charity/domain/models/volunteer.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

part 'charity_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1/charities")
abstract class CharityService {
  @factoryMethod
  factory CharityService(Dio dio) = _CharityService;

  @GET("")
  Future<List<Charity>> getCharities(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("sort") String sort,
    @Query("dir") String dir,
    @Query("q") String? query,
  );

  @GET("/id/{uuid}")
  Future<Charity> getCharityByID(
    @Path("uuid") String uuid,
  );

  @GET("/id/{id}/volunteers")
  Future<List<Volunteer>> getCharityVolunteers(
    @Path("id") String id,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("sort") String sort,
    @Query("dir") String dir,
    @Query("q") String? query,
  );

  @GET("/id/{charityId}/campaigns")
  Future<List<CharityCampaign>> getCharityCampaigns(
    @Path("charityId") String charityId,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("sort") String sort,
    @Query("dir") String dir,
    @Query("q") String? query,
  );

  @GET("/id/{charityId}/campaigns/available")
  Future<List<CharityCampaign>> getAvailableCharityCampaigns(
    @Path("charityId") String charityId,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("sort") String sort,
    @Query("dir") String dir,
    @Query("q") String? query,
  );

  @GET("/campaigns/id/{charityId}")
  Future<CharityCampaign> getCharityCampaignDetail(
    @Path("charityId") String charityId,
  );

  @GET("/campaigns/donors")
  Future<List<User>> getCharityDonors(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("sort") String sort,
    @Query("dir") String dir,
    @Query("q") String? query,
    @Query("charity_campaign_id") String charityCampaignId,
  );

  @GET("/campaigns/id/{charityId}/images")
  Future<List<CharityCampaignImage>> getCharityCampaignImages(
    @Path("charityId") String charityId,
    @Query("sort") String sort,
    @Query("dir") String dir,
  );

  @POST("/campaigns/id/{charityCampaignId}/donate/check")
  Future<bool> checkIfDonatable(
    @Path("charityCampaignId") String charityCampaignId,
  );

  @GET("/donations")
  Future<List<CharityDonation>> getCharityDonations(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("q") String? query,
    @Query("charity_campaign_id") String? charityCampaignId,
  );
}
