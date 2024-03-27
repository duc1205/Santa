import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/hrm_payroll/data/repositories/hrm_payroll_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetPayrollAmountUsecase extends Usecase {
  final HrmPayrollRepository _hrmPayrollRepository;

  const GetPayrollAmountUsecase(this._hrmPayrollRepository);

  Future<int> run() => _hrmPayrollRepository.getPayrollAmount();
}
