import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/auth/domain/usecases/send_otp_usecase.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/result/hrm_payroll_success_page.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/widgets/payroll_cancel_dialog.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/activate_payroll_account_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/events/user_success_registration_event.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class HrmPayrollRegisterPageViewmodel extends AppViewModel {
  final GetSettingUsecase _getSettingUsecase;
  final SendOtpUsecase _sendOtpUsecase;
  final ActivatePayrollAccountUsecase _activatePayrollAccountUsecase;

  HrmPayrollRegisterPageViewmodel(
    this._getSettingUsecase,
    this._sendOtpUsecase,
    this._activatePayrollAccountUsecase,
  );

  TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final otpNode = FocusNode();
  final emailNode = FocusNode();

  late Language language;

  Timer? _timer;

  DateTime? _timeStartCountDown;

  String policiesUrl = '';

  String listCompany = '';

  final int countDownTime = 120;

  final _isCanClearSearch = false.obs;
  final _isOTPFocus = false.obs;
  final _isemailFocus = false.obs;
  final _isValidOTP = false.obs;
  final _showemailError = false.obs;
  final _showOTPError = false.obs;
  final _countDown = 0.obs;
  final _showOTPClearIcon = false.obs;
  final _showemailClearIcon = false.obs;
  final _isValidemail = false.obs;
  final _isAcceptTos = false.obs;

  bool get isCanClearSearch => _isCanClearSearch.value;

  bool get isOTPFocus => _isOTPFocus.value;

  bool get isemailFocus => _isemailFocus.value;

  bool get isValidOTP => _isValidOTP.value;

  bool get showemailError => _showemailError.value;

  bool get showOTPError => _showOTPError.value;

  int get countDown => _countDown.value;

  bool get showOTPClearIcon => _showOTPClearIcon.value;

  bool get showemailClearIcon => _showemailClearIcon.value;

  bool get isValidemail => _isValidemail.value;

  bool get isAcceptTos => _isAcceptTos.value;

  void setIsAcceptTos(bool val) => _isAcceptTos.value = val;

  bool get isSubmitable => isCanClearSearch && showOTPClearIcon && isAcceptTos;

  @override
  void initState() {
    _initListener();
    _getTOSLink();
    super.initState();
  }

  @override
  disposeState() {
    _timer?.cancel();
    super.disposeState();
  }

  void _initListener() {
    emailController.addListener(() => _isCanClearSearch.value = emailController.text.trim().isNotEmpty);
    otpController.addListener(() => _showOTPClearIcon.value = otpController.text.trim().isNotEmpty);
    emailNode.addListener(() {
      if (_isemailFocus.value != emailNode.hasFocus) {
        _isemailFocus.value = emailNode.hasFocus;
        _showemailError.value = isemailFocus ? false : !validateemail();
      }
    });
    otpNode.addListener(() {
      if (_isOTPFocus.value != otpNode.hasFocus) {
        _isOTPFocus.value = otpNode.hasFocus;
        _showOTPError.value = isOTPFocus ? false : !validateOtp();
      }
    });
  }

  void resetTimer() {
    _timeStartCountDown = DateTime.now();
    _countDown.value = countDownTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown <= 0) {
        timer.cancel();
      } else {
        _countDown.value--;
      }
    });
  }

  void onResumeApp() {
    if (countDown == 0) return;
    final now = DateTime.now();
    final deltaTime = now.difference(_timeStartCountDown ?? now).inSeconds;
    _countDown.value = countDownTime - deltaTime > 0 ? countDownTime - deltaTime : 0;
  }

  Future<Unit> sendOTP() async {
    await showLoading();
    final success = await run(
      () async => _sendOtpUsecase.run(
        phoneNumber: emailController.text,
        locale: language.getValue(),
        method: 3,
      ),
    );
    await hideLoading();
    if (success) {
      resetTimer();
    }
    return unit;
  }

  bool validateOtp() {
    final otpRegex = RegExp(r'^[0-9]{6}$');
    _isValidOTP.value = otpRegex.hasMatch(otpController.text);
    return isValidOTP;
  }

  bool validateemail() {
    final emailRegex = RegExp(r'^[0-9]{9,10}$');
    _isValidemail.value = emailRegex.hasMatch(emailController.text);
    return isValidemail;
  }

  Unit onCancelClicked() {
    Get.dialog(
      PayrollCancelDialog(onConfirm: () => Get.until((route) => Get.currentRoute == "/MainPage")),
      barrierDismissible: true,
    );

    return unit;
  }

  void launchPoliciesUrl() => launchUri(policiesUrl);

  void launchListCompanyUrl() => launchUri(listCompany);

  Future<Unit> _getTOSLink() async {
    await showLoading();
    final locale = language != Language.unknown ? language.getValue() : FormatHelper.getPlatformLocaleName();
    String termsAndConditionsUrlVi = "";
    String termsAndConditionsUrlEn = "";

    await run(() async {
      termsAndConditionsUrlVi = (await _getSettingUsecase.run(Constants.payrollPrivacyPolicyUrlVi)).value ?? '';
      termsAndConditionsUrlEn = (await _getSettingUsecase.run(Constants.payrollPrivacyPolicyUrlEn)).value ?? '';
      listCompany =
          (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.payrollListCompanyUrlVi : Constants.payrollListCompanyUrlEn))
                  .value ??
              '';
    });
    await hideLoading();
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

  Future<Unit> onRegisterAccount() async {
    await showLoading();

    final success = await run(() async {
      await _activatePayrollAccountUsecase.run(
        otp: otpController.text,
        email: emailController.text,
      );
    });

    await hideLoading();
    if (success) {
      backPageOrHome();
      locator<EventBus>().fire(const UserSuccessRegistrationEvent());
      await Get.to(() => const HrmPayrollSuccessPage());
    }
    return unit;
  }
}
