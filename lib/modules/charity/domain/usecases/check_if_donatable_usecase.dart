import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/charity/data/repositories/charity_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CheckIfDonatableUsecase extends Usecase {
  final CharityRepository _charityRepository;

  const CheckIfDonatableUsecase(this._charityRepository);

  Future<bool> run({required String id}) => _charityRepository.checkIfDonatable(id);
}
