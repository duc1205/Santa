import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/charity/domain/models/volunteer.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityVolunteersUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetCharityVolunteersUsecase(this._charityRepository);

  Future<List<Volunteer>> run({required String id, SortParams? sortParams, required int page, required int limit, String? query}) =>
      _charityRepository.getCharityVolunteers(id, sortParams, page, limit, query);
}
