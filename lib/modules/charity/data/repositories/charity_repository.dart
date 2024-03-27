import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/datasources/charity_remote_datasource.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign_image.dart';
import 'package:santapocket/modules/charity/domain/models/charity_donation.dart';
import 'package:santapocket/modules/charity/domain/models/volunteer.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

@lazySingleton
class CharityRepository {
  final CharityRemoteDatasource _charityRemoteDatasource;

  CharityRepository(this._charityRemoteDatasource);

  Future<List<Charity>> getCharities(SortParams? sortParams, int page, int limit, String? query) =>
      _charityRemoteDatasource.getCharities(sortParams, page, limit, query);

  Future<Charity> getCharityByID(String id) => _charityRemoteDatasource.getCharityByID(id);

  Future<List<Volunteer>> getCharityVolunteers(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityRemoteDatasource.getCharityVolunteers(id, sortParams, page, limit, query);

  Future<List<CharityCampaign>> getCharityCampaigns(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityRemoteDatasource.getCharityCampaigns(id, sortParams, page, limit, query);

  Future<CharityCampaign> getCharityCampaignDetail(String id) => _charityRemoteDatasource.getCharityCampaignDetail(id);

  Future<List<User>> getCharityDonors(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityRemoteDatasource.getCharityDonors(id, sortParams, page, limit, query);

  Future<List<CharityCampaignImage>> getCharityCampaignImages(String id, SortParams? sortParams) =>
      _charityRemoteDatasource.getCharityCampaignImages(id, sortParams);

  Future<List<CharityCampaign>> getAvailableCharityCampaigns(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityRemoteDatasource.getAvailableCharityCampaigns(id, sortParams, page, limit, query);

  Future<bool> checkIfDonatable(String id) => _charityRemoteDatasource.checkIfDonatable(id);

  Future<List<CharityDonation>> getCharityDonations(String id, SortParams? sortParams, int page, int limit, String? query) =>
      _charityRemoteDatasource.getCharityDonations(id, sortParams, page, limit, query);
}
