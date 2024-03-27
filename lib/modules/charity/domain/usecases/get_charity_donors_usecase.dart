import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityDonorsUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetCharityDonorsUsecase(this._charityRepository);

  Future<List<User>> run({required String id, SortParams? sortParams, required int page, required int limit, String? query}) =>
      _charityRepository.getCharityDonors(id, sortParams, page, limit, query);
}
