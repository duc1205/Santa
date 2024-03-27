import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/detail/widgets/hrm_payroll_detail_bottom_sheet.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/widgets/payroll_cancel_dialog.dart';
import 'package:santapocket/modules/hrm_payroll/domain/models/payroll_log.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/deactivate_payroll_account_usecase.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/get_payroll_amount_usecase.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/get_payroll_logs_usecase.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/events/user_unregister_account_event.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class HrmPayrollDetailPageViewmodel extends AppViewModel {
  final DeactivatePayrollAccountUsecase _deactivatePayrollAccountUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetPayrollAmountUsecase _getPayrollAmountUsecase;
  final GetPayrollLogsUsecase _getPayrollLogsUsecase;
  final GetProfileUsecase _getProfileUsecase;

  HrmPayrollDetailPageViewmodel(
    this._deactivatePayrollAccountUsecase,
    this._getSettingUsecase,
    this._getPayrollAmountUsecase,
    this._getPayrollLogsUsecase,
    this._getProfileUsecase,
  );

  String policiesUrl = '';
  final scrollController = ScrollController();

  int _page = 1;
  final int _limit = 10;
  final String _sort = "created_at";
  final String _dir = "desc";

  final _isRevealWallet = true.obs;
  final _canLoadMore = false.obs;
  final _userSalary = 0.obs;
  final _payrollLogs = Rx<List<PayrollLog>>([]);
  final _isLoadingMore = false.obs;
  final _user = Rx<User?>(null);

  bool get isRevealWallet => _isRevealWallet.value;

  bool get canLoadMore => _canLoadMore.value;

  int get userSalary => _userSalary.value;

  List<PayrollLog> get payrollLogs => _payrollLogs.value;

  int get userCoin => user?.gem ?? 0;

  bool get isLoadingMore => _isLoadingMore.value;

  User? get user => _user.value;

  @override
  void initState() {
    super.initState();
    _getTOSLink();
    _initListener();
    _fetchData();
  }

  void _initListener() {
    scrollController.addListener(() {
      onListViewScroll();
    });
  }

  Unit onRevealWalletClicked() {
    _isRevealWallet(!isRevealWallet);
    return unit;
  }

  void showBottomSheetBalanceNotEnoughReceive() {
    Get.bottomSheet(
      HrmPayrollDetailBottomSheet(
        onPolicyClicked: () => launchPoliciesUrl(),
        onUnregisterClick: () => onUnregisterClicked(),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
    );
  }

  void launchPoliciesUrl() {
    Get.back();
    launchUri(policiesUrl);
  }

  Unit onUnregisterClicked() {
    Get.back();
    Get.dialog(
      PayrollCancelDialog(onConfirm: () {
        unregisterAccount();
      }),
      barrierDismissible: true,
    );
    return unit;
  }

  Future<Unit> unregisterAccount() async {
    await showLoading();
    final success = await run(
      () async => _deactivatePayrollAccountUsecase.run(),
    );
    await hideLoading();
    if (success) {
      locator<EventBus>().fire(const UserUnregisterAccountEvent());
      Get.until((route) => Get.currentRoute == "/MainPage");
    }
    return unit;
  }

  Future<Unit> _getTOSLink() async {
    final locale = user?.locale ?? FormatHelper.getPlatformLocaleName();
    String termsAndConditionsUrlVi = "";
    String termsAndConditionsUrlEn = "";

    await run(() async {
      termsAndConditionsUrlVi = (await _getSettingUsecase.run(Constants.payrollPrivacyPolicyUrlVi)).value ?? '';
      termsAndConditionsUrlEn = (await _getSettingUsecase.run(Constants.payrollPrivacyPolicyUrlEn)).value ?? '';
    });
    if (termsAndConditionsUrlVi.isEmpty && termsAndConditionsUrlEn.isEmpty) {
      return unit;
    }
    //Display correct language VI = VI , EN = EN
    //If you only add the VI link, it will display both languages
    //If you only add the EN link, only EN will be displayed
    policiesUrl = termsAndConditionsUrlVi.isEmpty && locale == (Language.en.getValue())
        ? termsAndConditionsUrlEn
        : termsAndConditionsUrlVi.isNotEmpty
            ? termsAndConditionsUrlVi
            : locale == (Language.vi.getValue())
                ? termsAndConditionsUrlVi
                : termsAndConditionsUrlEn;
    return unit;
  }

  Future<Unit> _fetchData({bool isShouldShowLoading = true}) async {
    late int userSalaryLoaded;
    late List<PayrollLog> payrollLogsLoaded;
    late User? userLoaded;

    if (isShouldShowLoading) await showLoading();
    final listParams = ListParams(
      paginationParams: PaginationParams(page: _page, limit: _limit),
      sortParams: SortParams(attribute: _sort, direction: _dir),
    );
    final isSuccess = await run(() async {
      userSalaryLoaded = await _getPayrollAmountUsecase.run();
      payrollLogsLoaded = await _getPayrollLogsUsecase.run(listParams: listParams);
      userLoaded = await _getProfileUsecase.run();
    });
    if (isSuccess) {
      _userSalary.value = userSalaryLoaded;
      assignPayrollLogs(payrollLogsLoaded);
      _user.value = userLoaded;
    }
    if (isShouldShowLoading) await hideLoading();
    return unit;
  }

  void assignPayrollLogs(List<PayrollLog> currentCabinets) {
    if (_page == 1) {
      _payrollLogs.value = [];
    }
    _payrollLogs.value += currentCabinets;
    _canLoadMore.value = currentCabinets.isNotEmpty;
    _page++;
  }

  Future<Unit> onListViewScroll() async {
    if (!scrollController.hasClients || isLoadingMore) {
      return unit;
    }
    if (!canLoadMore) {
      return unit;
    }
    if (scrollController.position.atEdge) {
      bool isTop = scrollController.position.pixels == 0;
      if (!isTop) {
        await _onLoadMore();
      }
    }
    return unit;
  }

  Future<Unit> _onLoadMore() async {
    _isLoadingMore.value = true;
    await _fetchData(isShouldShowLoading: false);
    _isLoadingMore.value = false;
    return unit;
  }

  void getToTopupPage() {
    Get.to(() => const PaymentPage(
          paymentMethod: PaymentMethod.santaPayroll,
        ));
  }

  Future<Unit> refreshPayrolls() async {
    _page = 1;
    return _fetchData(isShouldShowLoading: false);
  }
}
