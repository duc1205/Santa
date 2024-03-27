import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityCampaignDetailUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetCharityCampaignDetailUsecase(this._charityRepository);

  Future<CharityCampaign> run(String id) => _charityRepository.getCharityCampaignDetail(id);
}
