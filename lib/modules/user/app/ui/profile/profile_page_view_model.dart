import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/shortcuts_manager.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/app/ui/login/enter_phone_page.dart';
import 'package:santapocket/modules/auth/app/ui/login/widgets/change_language_dialog.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/boarding/app/ui/splash/splash_page.dart';
import 'package:santapocket/modules/connection/domain/enums/connection_status.dart';
import 'package:santapocket/modules/connection/domain/events/connection_status_changed_event.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/detail/hrm_payroll_detail_page.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/info/hrm_payroll_info_page.dart';
import 'package:santapocket/modules/hrm_payroll/domain/enums/payroll_status_type.dart';
import 'package:santapocket/modules/hrm_payroll/domain/usecases/check_payroll_status_usecase.dart';
import 'package:santapocket/modules/referral_campaign/domain/events/marketing_referral_campaign_finished_event.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:santapocket/modules/referral_campaign/domain/usecases/check_referral_code_usecase.dart';
import 'package:santapocket/modules/referral_campaign/domain/usecases/get_running_referral_campaign_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/logout_dialog.dart';
import 'package:santapocket/modules/user/domain/events/user_balance_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_coin_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_language_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_profile_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_success_registration_event.dart';
import 'package:santapocket/modules/user/domain/events/user_unregister_account_event.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/logout_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/update_profile_usecase.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

@injectable
class ProfilePageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final LogoutUsecase _logoutUsecase;
  final CheckReferralCodeUsecase _checkReferralCodeUsecase;
  final GetRunningReferralCampaignUsecase _getRunningReferralCampaignUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final CheckPayrollStatusUsecase _checkPayrollStatusUsecase;

  StreamSubscription? _listenUserBalanceChanged;
  StreamSubscription? _listenUserInfoChanged;
  StreamSubscription? _listenUserCoinChanged;
  StreamSubscription? _listenInternetConnection;
  StreamSubscription? _listenMarketingReferralCampaignFinish;
  StreamSubscription? _listenUserSuccessRegistrationEvent;
  StreamSubscription? _listenUserUnregisterAccountEvent;

  ProfilePageViewModel(
    this._getProfileUsecase,
    this._updateProfileUsecase,
    this._logoutUsecase,
    this._checkReferralCodeUsecase,
    this._getRunningReferralCampaignUsecase,
    this._getSettingUsecase,
    this._checkPayrollStatusUsecase,
  );

  final _user = Rx<User?>(null);
  final _referralCampaign = Rx<ReferralCampaign?>(null);
  final _language = Rx<Language>(Language.unknown);
  final _changeLanguage = Rx<Language>(Language.unknown);
  final _isReferralAvailable = RxBool(false);
  final _shareUrl = RxString("");
  final _payrollStatus = Rx<PayrollStatusType>(PayrollStatusType.unknown);

  User? get user => _user.value;

  ReferralCampaign? get referralCampaign => _referralCampaign.value;

  Language get language => _language.value;

  Language get changeLanguage => _changeLanguage.value;

  bool get isReferralAvailable => _isReferralAvailable.value;

  String get shareUrl => _shareUrl.value;

  PayrollStatusType get payrollStatus => _payrollStatus.value;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _listenUserBalanceChanged = locator<EventBus>().on<UserBalanceChangedEvent>().listen((event) async {
      await onUserBalanceChanged(event.user);
    });
    _listenUserCoinChanged = locator<EventBus>().on<UserCoinChangedEvent>().listen((event) async {
      await onUserCoinChanged(event.user);
    });
    _listenUserInfoChanged = locator<EventBus>().on<UserProfileChangedEvent>().listen((event) async {
      await onUserInfoChanged(event.user);
    });
    _listenInternetConnection = locator<EventBus>().on<ConnectionStatusChangedEvent>().listen((event) {
      if (event.status == ConnectionStatus.connected) {
        onRefresh();
      }
    });
    _listenMarketingReferralCampaignFinish = locator<EventBus>().on<MarketingReferralCampaignFinishedEvent>().listen((event) {
      onRefresh();
    });
    _listenUserSuccessRegistrationEvent = locator<EventBus>().on<UserSuccessRegistrationEvent>().listen((event) {
      onRefresh();
    });
    _listenUserUnregisterAccountEvent = locator<EventBus>().on<UserUnregisterAccountEvent>().listen((event) {
      onRefresh();
    });
  }

  @override
  void disposeState() {
    _listenUserBalanceChanged?.cancel();
    _listenUserInfoChanged?.cancel();
    _listenUserCoinChanged?.cancel();
    _listenInternetConnection?.cancel();
    _listenMarketingReferralCampaignFinish?.cancel();
    _listenUserSuccessRegistrationEvent?.cancel();
    _listenUserUnregisterAccountEvent?.cancel();
    super.disposeState();
  }

  Future<void> onUserBalanceChanged(User user) async {
    _user.value = null;
    _user.value = user;
  }

  Future<void> onUserCoinChanged(User user) async {
    _user.value = null;
    _user.value = user;
  }

  Future<void> onUserInfoChanged(User user) async {
    _user.value = null;
    _user.value = user;
  }

  Future<Unit> onRefresh() async {
    unawaited(_fetchData());
    return unit;
  }

  Future<bool> _fetchData() async {
    late User userLoaded;
    late bool isReferralAvailableLoaded;
    ReferralCampaign? referralCampaignLoaded;
    late String shareUrlLoaded;
    PayrollStatusType payrollStatus = PayrollStatusType.unknown;

    await showLoading();
    final isSuccess = await run(
      () async {
        userLoaded = await _getProfileUsecase.run();
        isReferralAvailableLoaded = await _checkReferralCodeUsecase.run(userLoaded);
        referralCampaignLoaded = await _getRunningReferralCampaignUsecase.run();
        shareUrlLoaded = ((await _getSettingUsecase.run(Constants.mainAppNewUserReferralShareUrl)).value ?? "") as String;
        payrollStatus = await _checkPayrollStatusUsecase.run();
      },
    );
    if (isSuccess) {
      _user.value = null;
      _user.value = userLoaded;
      _language.value = userLoaded.locale?.toLanguage() ?? Language.unknown;
      _isReferralAvailable.value = isReferralAvailableLoaded;
      _referralCampaign.value = referralCampaignLoaded;
      _shareUrl.value = shareUrlLoaded;
      _payrollStatus.value = payrollStatus;
    }
    await hideLoading();
    return isSuccess;
  }

  void onLogOutClick() {
    Get.dialog(LogoutDialog(confirmLogOut: _confirmLogout));
  }

  Future<Unit> _confirmLogout() async {
    Get.back();
    await showLoading();
    final success = await run(
      () => _logoutUsecase.run(),
    );
    await hideLoading();
    if (success) {
      await Get.offAll(() => const EnterPhonePage());
    }
    return unit;
  }

  void onChangeLanguage() {
    _changeLanguage.value = language;
    Get.dialog(
      SGAlertDialog(
        title: LocaleKeys.user_change_language.trans(),
        bodyViewDistance: 10.h,
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
            LocaleKeys.user_save.trans(),
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
            LocaleKeys.user_cancel.trans(),
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
      late User userLoaded;
      Get.back();
      await showLoading();
      final isSuccess = await run(
        () async => userLoaded = await _updateProfileUsecase.run(locale: changeLanguage.getValue()),
      );
      await hideLoading();
      if (isSuccess) {
        _user.value = null;
        _user.value = userLoaded;
        _language.value = changeLanguage;
        await EasyLocalization.of(Get.context!)?.setLocale(Locale(changeLanguage.getValue()));
        await Get.updateLocale(Locale(changeLanguage.getValue()));
        ShortcutsManager.instance.removeAllShortcut();
        locator<EventBus>().fire(const UserLanguageChangedEvent());
        await Get.offAll(() => const SplashPage());
      }
    }
    return unit;
  }

  Unit launcReferralCampaignhUri() {
    String? url = referralCampaign?.infoUrl;
    launchUri(url ?? "");
    return unit;
  }

  void onActivatePayrollClicked() {
    if (payrollStatus == PayrollStatusType.non_registered) {
      Get.to(() => HrmPayrollInfoPage(language: language));
    } else {
      Get.to(
        () => const HrmPayrollDetailPage(),
      );
    }
  }
}
