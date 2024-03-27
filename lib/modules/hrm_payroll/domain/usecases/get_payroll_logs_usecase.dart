import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/hrm_payroll/data/repositories/hrm_payroll_repository.dart';
import 'package:santapocket/modules/hrm_payroll/domain/models/payroll_log.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetPayrollLogsUsecase extends Usecase {
  final HrmPayrollRepository _hrmPayrollRepository;

  const GetPayrollLogsUsecase(this._hrmPayrollRepository);

  Future<List<PayrollLog>> run({ListParams? listParams}) => _hrmPayrollRepository.getPayrollLogs(listParams: listParams);
}
