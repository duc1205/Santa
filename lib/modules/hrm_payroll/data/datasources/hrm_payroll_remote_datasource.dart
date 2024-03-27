import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/hrm_payroll/data/datasources/services/hrm_payroll_service.dart';
import 'package:santapocket/modules/hrm_payroll/domain/models/payroll_log.dart';

abstract class HrmPayrollRemoteDatasource {
  Future<List<PayrollLog>> getPayrollLogs({
    ListParams? listParams,
  });

  Future<void> activatePayrollAccount(Map<String, String> param);

  Future<void> deactivatePayrollAccount();

  Future<String> checkPayrollStatus();

  Future<int> getPayrollAmount();
}

@LazySingleton(as: HrmPayrollRemoteDatasource)
class HrmPayrollRemoteDatasourceImpl extends HrmPayrollRemoteDatasource {
  final HrmPayrollService _hrmPayrollService;

  HrmPayrollRemoteDatasourceImpl(this._hrmPayrollService);

  @override
  Future<void> activatePayrollAccount(Map<String, String> param) => _hrmPayrollService.activatePayrollAccount(param);

  @override
  Future<String> checkPayrollStatus() => _hrmPayrollService.checkPayrollStatus();

  @override
  Future<void> deactivatePayrollAccount() => _hrmPayrollService.deactivatePayrollAccount();

  @override
  Future<int> getPayrollAmount() => _hrmPayrollService.getPayrollAmount();

  @override
  Future<List<PayrollLog>> getPayrollLogs({
    ListParams? listParams,
  }) =>
      _hrmPayrollService.getPayrollLogs(
        page: listParams?.paginationParams?.page,
        limit: listParams?.paginationParams?.limit,
        sort: listParams?.sortParams?.attribute,
        dir: listParams?.sortParams?.direction,
      );
}
