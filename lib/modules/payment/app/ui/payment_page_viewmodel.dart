import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hl_vnpay/flutter_hl_vnpay.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/domain/enums/payroll_status_type.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/check_payroll_status_usecase.dart';
import 'package:santapocket/modules/payment/app/ui/hrm_payroll/hrm_payroll_transaction_confirmation_page.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_error.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_success.dart';
import 'package:santapocket/modules/payment/app/ui/widgets/topup_information_dialog.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_status.dart';
import 'package:santapocket/modules/payment/domain/events/vnpay_payment_finished_event.dart';
import 'package:santapocket/modules/payment/domain/models/momo_payment.dart';
import 'package:santapocket/modules/payment/domain/models/payment_order.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/modules/payment/domain/models/vnpay_payment.dart';
import 'package:santapocket/modules/payment/domain/usecases/create_payment_momo_usecase.dart';
import 'package:santapocket/modules/payment/domain/usecases/create_payment_vnpay_usecase.dart';
import 'package:santapocket/modules/payment/domain/usecases/get_bank_transfer_message_usecase.dart';
import 'package:santapocket/modules/payment/domain/usecases/get_payment_order_usecase.dart';
import 'package:santapocket/modules/payment/domain/usecases/get_payment_products_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class PaymentPageViewModel extends AppViewModel {
  final CreatePaymentMomoUsecase _createPaymentMomoUsecase;
  final CreatePaymentVnPayUsecase _createPaymentVnPayUsecase;
  final GetPaymentProductsUsecase _getPaymentProductsUsecase;
  final GetPaymentOrderUsecase _getPaymentOrderUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final GetBankTransferMessageUsecase _getBankTransferMessageUsecase;
  final CheckPayrollStatusUsecase _checkPayrollStatusUsecase;
  final EventBus _eventBus;

  StreamSubscription? _vnPayPaymentFinishedEventListener;

  PaymentPageViewModel(
    this._createPaymentMomoUsecase,
    this._createPaymentVnPayUsecase,
    this._getPaymentProductsUsecase,
    this._getPaymentOrderUsecase,
    this._getSettingUsecase,
    this._getProfileUsecase,
    this._getBankTransferMessageUsecase,
    this._eventBus,
    this._checkPayrollStatusUsecase,
  );

  final ScrollController controller = ScrollController();

  String sort = "price";
  String dir = "asc";

  String privacyPolicyUrl = '';

  final _orderId = Rx<String?>(null);
  final _isVnPayWalletPayment = Rx<bool>(false);
  final _indexItemSelected = Rx<int>(0);
  final _paymentProducts = Rx<List<PaymentProduct>>([]);
  final _defaultPaymentMethod = Rx<PaymentMethod?>(PaymentMethod.moMo);
  final _bankTransferInfo = Rx<Map<String, dynamic>>({});
  final _isBankTransferEnable = Rx<bool>(false);
  final _user = Rx<User?>(null);
  final _bankTransferMessage = Rx<String?>(null);
  final _vnpayHelpUrl = Rx<String>("");
  final _payrollStatus = Rx<PayrollStatusType>(PayrollStatusType.unknown);

  int get indexItemSelected => _indexItemSelected.value;

  List<PaymentProduct> get paymentProducts => _paymentProducts.value;

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  PaymentMethod? get defaultPaymentMethod => _defaultPaymentMethod.value;

  String? get orderId => _orderId.value;

  bool get isVnPayWalletPayment => _isVnPayWalletPayment.value;

  bool get isBankTransferEnable => _isBankTransferEnable.value;

  User? get user => _user.value;

  String get vnpayHelpUrl => _vnpayHelpUrl.value;

  PayrollStatusType get payrollStatus => _payrollStatus.value;

  Future<PaymentMethod?> setDefaultPaymentMethod(PaymentMethod paymentMethod) async {
    if (paymentMethod == defaultPaymentMethod) return paymentMethod;
    _defaultPaymentMethod.value = paymentMethod;
    if (paymentMethod == PaymentMethod.bankTransfer) {
      unawaited(_getBankTransferMessage());
      await Future.delayed(const Duration(milliseconds: 500));
      _scrollDown();
    }
    return _defaultPaymentMethod.value;
  }

  int getBonus(int index) => paymentProducts[index].bonus;

  int getAmount(int index) => paymentProducts[index].price;

  int getCoin(int index) => FormatHelper.roundSantaXu(paymentProducts[index].price);

  int getPromoValue(int index) => FormatHelper.roundSantaXu((paymentProducts[index].value) - (paymentProducts[index].price));

  int getAmountTopUp() => paymentProducts.isNotEmpty ? paymentProducts[indexItemSelected].price : 0;

  int setItemSelected(int index) => _indexItemSelected.value = index;

  String? get bankTransferMessage => _bankTransferMessage.value;

  bool get isBankTransfer => defaultPaymentMethod == PaymentMethod.bankTransfer;

  String get helpCenterUrl => _vnpayHelpUrl.value;

  @override
  Future<void> initState() async {
    _registerEvent();
    await _getData();
    await _getVnPayHelpInfoSetting();
    await _getTOSLink();
    super.initState();
  }

  @override
  void disposeState() {
    _vnPayPaymentFinishedEventListener?.cancel();
    super.disposeState();
  }

  void _registerEvent() {
    _vnPayPaymentFinishedEventListener = _eventBus.on<VnPayPaymentFinishedEvent>().listen((event) {
      getPaymentOrder();
    });
  }

  Future<Unit> refreshData() async {
    await _getData();
    await _getVnPayHelpInfoSetting();
    await _getTOSLink();
    return unit;
  }

  Future<Unit> _getData() async {
    late Map<String, dynamic> bankTransferInfoLoaded;
    late bool bankTransferEnableLoaded;
    late List<PaymentProduct> paymentProductsLoaded;
    late User userLoaded;
    late String bankTransferMessage;
    PayrollStatusType payrollStatusLoaded = PayrollStatusType.unknown;

    await showLoading();
    final success = await run(() async {
      final bankTransferInfoFetched = (await _getSettingUsecase.run(Constants.appBankTransferInfo)).value;
      if (bankTransferInfoFetched is Map<String, dynamic>) {
        bankTransferInfoLoaded = bankTransferInfoFetched;
      }
      bankTransferEnableLoaded = (await _getSettingUsecase.run(Constants.appBankTransferEnable)).value as bool;
      paymentProductsLoaded = await _getPaymentProductsUsecase.run(SortParams(direction: dir, attribute: sort));
      userLoaded = await _getProfileUsecase.run();
      bankTransferMessage = await _getBankTransferMessageUsecase.run();
      payrollStatusLoaded = await _checkPayrollStatusUsecase.run();
    });
    await hideLoading();
    if (success) {
      _bankTransferInfo.value = bankTransferInfoLoaded;
      _isBankTransferEnable.value = bankTransferEnableLoaded;
      _paymentProducts.value = paymentProductsLoaded;
      _user.value = userLoaded;
      _bankTransferMessage.value = bankTransferMessage;
      _payrollStatus.value = payrollStatusLoaded;
    }
    return unit;
  }

  Future<Unit> _getBankTransferMessage() async {
    late String bankTransferMessage;
    final success = await run(() async {
      _bankTransferMessage.value = "";
      bankTransferMessage = await _getBankTransferMessageUsecase.run();
    });
    if (success) {
      _bankTransferMessage.value = bankTransferMessage;
    }
    return unit;
  }

  Future<Unit> getPaymentOrder() async {
    if (orderId == null || !isVnPayWalletPayment) return unit;
    late PaymentOrder paymentOrder;
    _isVnPayWalletPayment.value = false;
    await showLoading();
    final success = await run(
      () async => paymentOrder = await _getPaymentOrderUsecase.run(orderId: orderId!),
    );
    await hideLoading();
    if (success) {
      switch (paymentOrder.status) {
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
                amount: getAmountTopUp(),
                paymentMethod: PaymentMethod.vnPay,
                paymentOrder: paymentOrder,
              ));
          break;
      }
    }
    return unit;
  }

  Future<Unit> onTopUpButtonClicked() async {
    switch (defaultPaymentMethod) {
      case PaymentMethod.moMo:
        await _paymentMomo();
        break;
      case PaymentMethod.vnPay:
        await _paymentVnPay();
        break;
      case PaymentMethod.santaPayroll:
        await Get.to(() => HrmPayrollTransactionConfirmationPage(
              paymentProduct: paymentProducts.elementAt(indexItemSelected),
              locale: user?.locale ?? "",
              getCoinAmount: getCoin(indexItemSelected),
              getPrice: getAmount(indexItemSelected),
              getCoinPromo: getPromoValue(indexItemSelected),
            ));
        break;
      case PaymentMethod.bankTransfer:

      case null:
        break;
    }
    return unit;
  }

  Future<Unit> _paymentMomo() async {
    late MomoPayment momoPayment;
    await showLoading();
    final success = await run(
      () async =>
          momoPayment = await _createPaymentMomoUsecase.run(orderInfo: Constants.orderInfoPayment, productId: paymentProducts[indexItemSelected].id),
    );
    await hideLoading();
    if (success && momoPayment.deepLink != null) {
      await openUrl(momoPayment.deepLink ?? "");
    }
    return unit;
  }

  Future<Unit> openUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      showToast(LocaleKeys.payment_momo_app_not_installed.trans());
    }
    return unit;
  }

  Future<Unit> _paymentVnPay() async {
    late VnPayPayment vnPayPayment;
    await showLoading();
    final success = await run(
      () async => vnPayPayment =
          await _createPaymentVnPayUsecase.run(orderInfo: Constants.orderInfoPayment, productId: paymentProducts[indexItemSelected].id),
    );
    await hideLoading();
    if (success && vnPayPayment.redirectUrl != null) {
      _orderId.value = vnPayPayment.orderId;
      try {
        final int? vnpCode = await FlutterHlVnpay.instance.show(
          paymentUrl: vnPayPayment.redirectUrl!,
          tmnCode: Config.vnpayTmnCode,
          scheme: Config.vnpayDeepLink,
          isSandbox: Config.vnpaySandbox,
        );
        switch (vnpCode) {
          case 0:
            await Get.to(() => PaymentSuccess(amount: getAmountTopUp(), paymentMethod: PaymentMethod.vnPay));
            break;
          case 24:
            showToast(LocaleKeys.payment_payment_cancel.trans());
            break;
          case 99:
            await Get.to(() => const PaymentError());
            break;
          case 10:
            _isVnPayWalletPayment.value = true;
            break;
        }
      } on PlatformException {
        showToast(LocaleKeys.payment_system_error.trans());
      } catch (error) {
        showToast(LocaleKeys.payment_system_error.trans());
      }
    }
    return unit;
  }

  Future<Unit> openTopupConfirmDialog() async {
    if (defaultPaymentMethod == PaymentMethod.santaPayroll) {
      await onTopUpButtonClicked();
      return unit;
    }
    await Get.dialog(
      TopupInformationDialog(
        onConfirm: () async {
          Get.back();
          await onTopUpButtonClicked();
        },
        onPressHere: launchPrivacyPolicyUrl,
      ),
      barrierDismissible: false,
    );
    return unit;
  }

  Future<Unit> _getTOSLink() async {
    final locale = user?.locale ?? FormatHelper.getPlatformLocaleName();
    privacyPolicyUrl =
        (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.paymentUserTopupPolicyVI : Constants.paymentUserTopupPolicyEN))
                .value ??
            '';
    return unit;
  }

  void launchPrivacyPolicyUrl() => launchUri(privacyPolicyUrl);

  void _scrollDown() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.linearToEaseOut,
    );
  }

  Future<Unit> _getVnPayHelpInfoSetting() async {
    late String vnpayHelpUrlFetch;
    final success = await run(() async {
      vnpayHelpUrlFetch = (await _getSettingUsecase.run(Constants.mainAppVnpayInstructionUrlVi)).value ?? "";
    });
    if (success) {
      _vnpayHelpUrl.value = vnpayHelpUrlFetch;
    }
    return unit;
  }

  void navigatateToVnpayHelpWebview() {
    if (vnpayHelpUrl.isNotEmpty) {
      Get.to(() => WebViewPage(url: vnpayHelpUrl));
    }
  }
}
