import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/get_payroll_amount_usecase.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_error.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_success.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_status.dart';
import 'package:santapocket/modules/payment/domain/models/payment_order.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/modules/payment/domain/usecases/topup_payroll_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class HrmPayrollTransactionConfirmationPageViewmodel extends AppViewModel {
  final GetSettingUsecase _getSettingUsecase;
  final GetPayrollAmountUsecase _getPayrollAmountUsecase;
  final TopupPayrollUsecase _topupPayrollUsecase;

  HrmPayrollTransactionConfirmationPageViewmodel(this._getSettingUsecase, this._getPayrollAmountUsecase, this._topupPayrollUsecase);

  String locale = "";
  late PaymentProduct paymentProduct;
  String policiesUrl = '';

  final _isRevealWallet = true.obs;
  final _isAcceptTos = false.obs;
  final _userSalary = 0.obs;

  bool get isRevealWallet => _isRevealWallet.value;

  bool get isAcceptTos => _isAcceptTos.value;

  int get userSalary => _userSalary.value;

  void setIsAcceptTos(bool val) => _isAcceptTos.value = val;

  @override
  void initState() {
    super.initState();
    _getTOSLink();
    _fetchData();
  }

  Unit onRevealWalletClicked() {
    _isRevealWallet(!isRevealWallet);
    return unit;
  }

  void launchPoliciesUrl() => launchUri(policiesUrl);

  Future<Unit> _getTOSLink() async {
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

  Future<Unit> _fetchData({bool showShowLoading = true}) async {
    late int userSalaryLoaded;

    if (showShowLoading) await showLoading();
    final isSuccess = await run(() async {
      userSalaryLoaded = await _getPayrollAmountUsecase.run();
    });
    if (isSuccess) {
      _userSalary.value = userSalaryLoaded;
    }
    if (showShowLoading) await hideLoading();
    return unit;
  }

  Future<Unit> topupPayroll() async {
    late PaymentOrder paymentOrderLoaded;
    await showLoading();
    final isSuccess = await run(() async {
      paymentOrderLoaded = await _topupPayrollUsecase.run(paymentProductId: paymentProduct.id);
    });
    await hideLoading();
    if (isSuccess) {
      switch (paymentOrderLoaded.status) {
        case PaymentStatus.unknown:
          break;
        case PaymentStatus.create:
          showToast(LocaleKeys.payment_payment_cancel.trans());
          break;
        case PaymentStatus.fail:
          await Get.to(() => const PaymentError());
          break;
        case PaymentStatus.success:
          await Get.to(() => PaymentSuccess(
                amount: paymentOrderLoaded.amount,
                paymentMethod: PaymentMethod.santaPayroll,
                paymentOrder: paymentOrderLoaded,
              ));
          break;
      }
    }

    return unit;
  }
}
