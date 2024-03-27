import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/datasources/services/charity_service.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign_image.dart';
import 'package:santapocket/modules/charity/domain/models/charity_donation.dart';
import 'package:santapocket/modules/charity/domain/models/volunteer.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

abstract class CharityRemoteDatasource {
  Future<List<Charity>> getCharities(SortParams? sortParams, int page, int limit, String? query);

  Future<Charity> getCharityByID(String id);

  Future<List<Volunteer>> getCharityVolunteers(String id, SortParams? sortParams, int page, int limit, String? query);

  Future<List<CharityCampaign>> getCharityCampaigns(String id, SortParams? sortParams, int page, int limit, String? query);

  Future<List<CharityCampaign>> getAvailableCharityCampaigns(String id, SortParams? sortParams, int page, int limit, String? query);

  Future<CharityCampaign> getCharityCampaignDetail(String id);

  Future<List<User>> getCharityDonors(String id, SortParams? sortParams, int page, int limit, String? query);

  Future<List<CharityCampaignImage>> getCharityCampaignImages(String id, SortParams? sortParams);

  Future<bool> checkIfDonatable(String id);

  Future<List<CharityDonation>> getCharityDonations(String id, SortParams? sortParams, int page, int limit, String? query);
}

@LazySingleton(as: CharityRemoteDatasource)
class CharityRemoteDatasourceImpl extends CharityRemoteDatasource {
  final CharityService _charityService;

  CharityRemoteDatasourceImpl(this._charityService);

  @override
  Future<List<Charity>> getCharities(SortParams? sortParams, int page, int limit, String? query) => _charityService.getCharities(
        page,
        limit,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
        query,
      );

  @override
  Future<Charity> getCharityByID(String id) => _charityService.getCharityByID(id);

  @override
  Future<List<Volunteer>> getCharityVolunteers(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityService.getCharityVolunteers(
        id,
        page,
        limit,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
        query,
      );

  @override
  Future<List<CharityCampaign>> getCharityCampaigns(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityService.getCharityCampaigns(
        id,
        page,
        limit,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
        query,
      );

  @override
  Future<List<CharityCampaign>> getAvailableCharityCampaigns(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityService.getAvailableCharityCampaigns(
        id,
        page,
        limit,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
        query,
      );

  @override
  Future<CharityCampaign> getCharityCampaignDetail(String id) => _charityService.getCharityCampaignDetail(id);

  @override
  Future<List<User>> getCharityDonors(String id, SortParams? sortParams, int page, int limit, String? query) => _charityService.getCharityDonors(
        page,
        limit,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
        query,
        id,
      );

  @override
  Future<List<CharityCampaignImage>> getCharityCampaignImages(String id, SortParams? sortParams) => _charityService.getCharityCampaignImages(
        id,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
      );

  @override
  Future<bool> checkIfDonatable(String id) => _charityService.checkIfDonatable(id);

  @override
  Future<List<CharityDonation>> getCharityDonations(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityService.getCharityDonations(
        page,
        limit,
        sortParams?.attribute ?? "",
        sortParams?.direction ?? "",
        query,
        id,
      );
}
