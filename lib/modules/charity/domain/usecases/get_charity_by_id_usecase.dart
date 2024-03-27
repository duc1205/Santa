import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityByIdUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const GetCharityByIdUsecase(this._charityRepository);

  Future<Charity> run(String id) => _charityRepository.getCharityByID(id);
}
