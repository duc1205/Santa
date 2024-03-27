import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/hrm_payroll/data/repositories/hrm_payroll_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ActivatePayrollAccountUsecase extends Usecase {
  final HrmPayrollRepository _hrmPayrollRepository;

  const ActivatePayrollAccountUsecase(this._hrmPayrollRepository);

  Future<void> run({
    required String otp,
    required String email,
  }) =>
      _hrmPayrollRepository.activatePayrollAccount({
        "otp": otp,
        "email": email,
      });
}
