import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign_image.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityCampaignImagesUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetCharityCampaignImagesUsecase(this._charityRepository);

  Future<List<CharityCampaignImage>> run({required String id, SortParams? sortParams}) => _charityRepository.getCharityCampaignImages(id, sortParams);
}
