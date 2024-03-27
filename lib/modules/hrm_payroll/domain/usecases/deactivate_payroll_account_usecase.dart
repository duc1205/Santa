import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/hrm_payroll/data/repositories/hrm_payroll_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DeactivatePayrollAccountUsecase extends Usecase {
  final HrmPayrollRepository _hrmPayrollRepository;

  const DeactivatePayrollAccountUsecase(this._hrmPayrollRepository);

  Future<void> run() => _hrmPayrollRepository.deactivatePayrollAccount();
}
