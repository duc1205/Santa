import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharitiesUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetCharitiesUsecase(this._charityRepository);

  Future<List<Charity>> run({SortParams? sortParams, required int page, required int limit, String? query}) =>
      _charityRepository.getCharities(sortParams, page, limit, query);
}
