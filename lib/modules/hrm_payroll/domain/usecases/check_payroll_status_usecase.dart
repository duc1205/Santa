import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/hrm_payroll/data/repositories/hrm_payroll_repository.dart';
import 'package:santapocket/modules/hrm_payroll/domain/enums/payroll_status_type.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CheckPayrollStatusUsecase extends Usecase {
  final HrmPayrollRepository _hrmPayrollRepository;

  const CheckPayrollStatusUsecase(this._hrmPayrollRepository);

  Future<PayrollStatusType> run() async {
    String status = jsonDecode(await _hrmPayrollRepository.checkPayrollStatus());
    return PayrollStatusType.values.firstWhere((e) => e.name == status);
  }
}
