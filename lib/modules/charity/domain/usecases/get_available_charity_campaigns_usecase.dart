import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetAvailableCharityCampaignsUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetAvailableCharityCampaignsUsecase(this._charityRepository);

  Future<List<CharityCampaign>> run({required String id, SortParams? sortParams, required int page, required int limit, String? query}) =>
      _charityRepository.getAvailableCharityCampaigns(id, sortParams, page, limit, query);
}
