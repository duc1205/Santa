import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/hrm_payroll/data/datasources/hrm_payroll_remote_datasource.dart';
import 'package:santapocket/modules/hrm_payroll/domain/models/payroll_log.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class HrmPayrollRepository extends Repository {
  final HrmPayrollRemoteDatasource _hrmPayrollRemoteDatasource;

  const HrmPayrollRepository(this._hrmPayrollRemoteDatasource);

  Future<void> activatePayrollAccount(Map<String, String> param) => _hrmPayrollRemoteDatasource.activatePayrollAccount(param);

  Future<void> deactivatePayrollAccount() => _hrmPayrollRemoteDatasource.deactivatePayrollAccount();

  Future<String> checkPayrollStatus() => _hrmPayrollRemoteDatasource.checkPayrollStatus();

  Future<int> getPayrollAmount() => _hrmPayrollRemoteDatasource.getPayrollAmount();

  Future<List<PayrollLog>> getPayrollLogs({
    ListParams? listParams,
  }) =>
      _hrmPayrollRemoteDatasource.getPayrollLogs(
        listParams: listParams,
      );
}
