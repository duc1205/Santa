import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/firebase/domain/usecases/register_fcm_token_usecase.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/auth/app/ui/login/widgets/change_language_dialog.dart';
import 'package:santapocket/modules/auth/app/ui/login/widgets/select_country_page.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/auth/domain/models/country.dart';
import 'package:santapocket/modules/auth/domain/usecases/get_countries_usecase.dart';
import 'package:santapocket/modules/auth/domain/usecases/send_otp_usecase.dart';
import 'package:santapocket/modules/main/app/ui/main_page.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_page.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_select_type_page.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/agree_tos_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/update_profile_usecase.dart';
import 'package:santapocket/oauth2/oauth2_manager.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

@injectable
class EnterPhonePageViewModel extends AppViewModel {
  final int countDownTime = 120;
  static const String _defaultVietNamPhoneCode = "+84";
  final phoneNode = FocusNode();
  final otpNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final SendOtpUsecase _sendOtpUsecase;
  final GetCountriesUsecase _getCountriesUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final RegisterFcmTokenUsecase _registerFcmTokenUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final AgreeTosUsecase _agreeTosUsecase;

  EnterPhonePageViewModel(
    this._sendOtpUsecase,
    this._getCountriesUsecase,
    this._getProfileUsecase,
    this._registerFcmTokenUsecase,
    this._updateProfileUsecase,
    this._getSettingUsecase,
    this._agreeTosUsecase,
  );

  String currentCountryPhoneCode = _defaultVietNamPhoneCode;
  String phoneWithCountryCode = '';
  String termsAndConditionsUrl = '';
  String privacyPolicyUrl = '';

  final _countries = RxList<Country>([]);
  final _sendOTPMethod = 2.obs;
  final _language = Rx<Language>(Language.unknown);
  final _changeLanguage = Rx<Language>(Language.unknown);
  final _isPhoneFocus = false.obs;
  final _isOTPFocus = false.obs;
  final _showPhoneClearIcon = false.obs;
  final _showOTPClearIcon = false.obs;
  final _isValidPhone = false.obs;
  final _isValidOTP = false.obs;
  final _showPhoneError = false.obs;
  final _showOTPError = false.obs;
  final _countDown = 0.obs;
  final _isAcceptTos = false.obs;

  List<Country> get countries => _countries;

  Language get language => _language.value;

  Language get changeLanguage => _changeLanguage.value;

  int get sendOTPMethod => _sendOTPMethod.value;

  bool get isPhoneFocus => _isPhoneFocus.value;

  bool get isOTPFocus => _isOTPFocus.value;

  bool get showPhoneClearIcon => _showPhoneClearIcon.value;

  bool get showOTPClearIcon => _showOTPClearIcon.value;

  bool get isValidPhone => _isValidPhone.value;

  bool get isValidOTP => _isValidOTP.value;

  bool get showPhoneError => _showPhoneError.value;

  bool get showOTPError => _showOTPError.value;

  int get countDown => _countDown.value;

  bool get isAcceptTos => _isAcceptTos.value;

  void setSendOTPMethod(int val) => _sendOTPMethod.value = val;

  void setIsAcceptTos(bool val) => _isAcceptTos.value = val;

  Timer? _timer;

  DateTime? _timeStartCountDown;

  @override
  void initState() {
    _onInit();
    _initListener();
    super.initState();
  }

  @override
  void disposeState() {
    phoneController.dispose();
    phoneNode.dispose();
    otpController.dispose();
    otpNode.dispose();
    _timer?.cancel();
    super.disposeState();
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

  void _initListener() {
    phoneNode.addListener(() {
      if (_isPhoneFocus.value != phoneNode.hasFocus) {
        _isPhoneFocus.value = phoneNode.hasFocus;
        _showPhoneError.value = isPhoneFocus ? false : !validatePhone();
      }
      _showPhoneClearIcon.value = isPhoneFocus && phoneController.text.isNotEmpty;
    });
    phoneController.addListener(() {
      _showPhoneClearIcon.value = phoneController.text.isNotEmpty;
    });

    otpNode.addListener(() {
      if (_isOTPFocus.value != otpNode.hasFocus) {
        _isOTPFocus.value = otpNode.hasFocus;
        _showOTPError.value = isOTPFocus ? false : !validateOtp();
      }
      _showOTPClearIcon.value = isOTPFocus && otpController.text.isNotEmpty;
    });
    otpController.addListener(() {
      _showOTPClearIcon.value = otpController.text.isNotEmpty;
    });
  }

  void launchTermsAndConditionsUrl() => launchUri(termsAndConditionsUrl);

  void launchPrivacyPolicyUrl() => launchUri(privacyPolicyUrl);

  void setLanguage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = Localizations.localeOf(context).toString();
      _language.value = locale == 'vi' ? Language.vi : Language.en;
    });
  }

  bool validateOtp() {
    final otpRegex = RegExp(r'^[0-9]{6}$');
    _isValidOTP.value = otpRegex.hasMatch(otpController.text);
    return isValidOTP;
  }

  bool validatePhone() {
    final phoneRegex = RegExp(r'^[0-9]{9,10}$');
    _isValidPhone.value = phoneRegex.hasMatch(phoneController.text);
    return isValidPhone;
  }

  Future<Unit> _onInit() async {
    await showLoading();

    await run(
      () async {
        _countries.value = await _getCountriesUsecase.run();
      },
    );
    await _getTOSLink();
    await hideLoading();
    return unit;
  }

  Future<Unit> _getTOSLink() async {
    await showLoading();
    final locale = language != Language.unknown ? language.getValue() : FormatHelper.getPlatformLocaleName();

    await run(() async {
      termsAndConditionsUrl =
          (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.termsAndConditionsUrlVI : Constants.termsAndConditionsUrlEN))
                  .value ??
              '';
      privacyPolicyUrl =
          (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.privacyPolicyUrlVI : Constants.privacyPolicyUrlEN)).value ?? '';
    });

    await hideLoading();
    return unit;
  }

  Future<Unit> sendOTP() async {
    phoneWithCountryCode = FormatHelper.formatPhone(currentCountryPhoneCode, phoneController.text);
    await showLoading();
    final success = await run(
      () async => _sendOtpUsecase.run(
        phoneNumber: phoneWithCountryCode,
        locale: language.getValue(),
        method: sendOTPMethod,
      ),
    );
    await hideLoading();
    if (success) {
      resetTimer();
    }
    return unit;
  }

  Future<Unit> loginViaPhone() async {
    if (!isAcceptTos) {
      return unit;
    }
    phoneWithCountryCode = FormatHelper.formatPhone(currentCountryPhoneCode, phoneController.text);
    await showLoading();
    final isSuccess = await run(
      () => Oauth2Manager.instance.loginPasswordGrant(phoneWithCountryCode, otpController.text),
    );
    if (isSuccess) {
      unawaited(_registerFcmTokenUsecase.run());
      unawaited(_agreeTosUsecase.run());
      final user = await getUserProfile();
      if (user != null) {
        final locale = Locale(language.getValue()).toString();
        if (user.locale != locale) {
          await _updateProfileUsecase.run(locale: locale);
        }
        await hideLoading();
        if (user.shouldWizardName) {
          await Get.offAll(() => WizardProfilePage(
                username: user.name,
              ));
        } else if (user.shouldWizardType) {
          await Get.offAll(() => const WizardProfileSelectTypePage(
                isFirstLogin: false,
              ));
        } else {
          await Get.offAll(() => const MainPage());
        }
      }
    }
    await hideLoading();
    return unit;
  }

  Future<User?> getUserProfile() async {
    User? user;
    await showLoading();
    await run(
      () async {
        user = await _getProfileUsecase.run();
      },
    );
    await hideLoading();
    return user;
  }

  void navigateToCountryPage() {
    Get.to(
      () => SelectCountryPage(
        countries: countries,
        currentCountryCode: currentCountryPhoneCode,
        onSelectedCountry: (country) {
          currentCountryPhoneCode = country.phoneCode;
        },
      ),
    );
  }

  void onLanguageClicked() {
    _changeLanguage.value = language;
    Get.dialog(
      SGAlertDialog(
        bodyViewDistance: 0,
        title: LocaleKeys.auth_change_language.trans(),
        bodyView: Obx(
          () => ChangeLanguageDialog(
            language: changeLanguage,
            onChangeLanguage: (newLanguage) => _changeLanguage.value = newLanguage,
          ),
        ),
        confirmButton: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: AppTheme.yellow1,
          ),
          onPressed: _onSubmitNewLanguage,
          child: Text(
            LocaleKeys.auth_save.trans(),
            style: AppTheme.white_14w600,
          ),
        ),
        cancelButton: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: AppTheme.border,
          ),
          onPressed: () => Get.back(),
          child: Text(
            LocaleKeys.auth_cancel.trans(),
            style: AppTheme.white_14w600,
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<Unit> _onSubmitNewLanguage() async {
    if (changeLanguage == language) {
      Get.back();
    } else {
      _language.value = changeLanguage;
      await EasyLocalization.of(Get.context!)?.setLocale(Locale(changeLanguage.getValue()));
      await Get.updateLocale(Locale(changeLanguage.getValue()));
      await _getTOSLink();
      Get.back();
    }
    return unit;
  }
}
