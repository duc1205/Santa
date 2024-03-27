import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/auth/data/repositories/auth_repository.dart';
import 'package:santapocket/modules/auth/domain/models/country.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCountriesUsecase extends Usecase {
  final AuthRepository _authRepository;

  const GetCountriesUsecase(this._authRepository);

  Future<List<Country>> run() => _authRepository.getCountries();
}
