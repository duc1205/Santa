import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/main/app/ui/main_page.dart';
import 'package:santapocket/modules/referral_campaign/app/ui/insert_code/referral_insert_code_page.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:santapocket/modules/referral_campaign/domain/usecases/check_referral_code_usecase.dart';
import 'package:santapocket/modules/referral_campaign/domain/usecases/get_running_referral_campaign_usecase.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_select_type_page.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/update_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WizardProfilePageViewModel extends AppViewModel {
  final UpdateProfileUsecase _updateProfileUsecase;
  final CheckReferralCodeUsecase _checkReferralCodeUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final GetRunningReferralCampaignUsecase _getRunningReferralCampaignUsecase;

  WizardProfilePageViewModel(
    this._updateProfileUsecase,
    this._checkReferralCodeUsecase,
    this._getProfileUsecase,
    this._getRunningReferralCampaignUsecase,
  );

  String userName = "";
  UserType userType = UserType.defaultType;

  String onChangeUserName(String name) => userName = name;

  UserType onChangeUserType(UserType type) => userType = type;

  final _user = Rx<User?>(null);
  final _referralCampaign = Rx<ReferralCampaign?>(null);
  final _isReferralAvailable = RxBool(false);

  User? get user => _user.value;
  ReferralCampaign? get referralCampaign => _referralCampaign.value;
  bool get isReferralAvailable => _isReferralAvailable.value;

  Future<Unit> updateUserName() async {
    if (userName.trim().isNotEmpty) {
      await showLoading();
      final isSuccess = await run(
        () => _updateProfileUsecase.run(name: userName),
      );
      await hideLoading();
      if (isSuccess) {
        await Get.to(() => const WizardProfileSelectTypePage(
              isFirstLogin: true,
            ));
      }
    } else {
      showToast(LocaleKeys.user_please_enter_full_name.trans());
    }
    return unit;
  }

  Future<Unit> updateUserType() async {
    if (userType.getValue().isNotEmpty) {
      await showLoading();
      final isSuccess = await run(
        () => _updateProfileUsecase.run(type: userType.getValue()),
      );
      await hideLoading();
      if (isSuccess) {
        await _fetchReferralCampaign();
        if (isReferralCampaignAvaiable()) {
          await Get.offAll(
            () => ReferralInsertCodePage(
              referralCampaign: referralCampaign,
              isFromRegistration: true,
            ),
          );
        } else {
          await Get.offAll(
            () => const MainPage(),
          );
        }
      }
    } else {
      showToast(LocaleKeys.user_please_choose_user_type.trans());
    }
    return unit;
  }

  Future<bool> _fetchReferralCampaign() async {
    late User userLoaded;
    late bool isReferralAvailableLoaded;
    ReferralCampaign? referralCampaignLoaded;

    await showLoading();
    final isSuccess = await run(
      shouldHandleError: false,
      () async {
        userLoaded = await _getProfileUsecase.run();
        isReferralAvailableLoaded = await _checkReferralCodeUsecase.run(userLoaded);
        if (isReferralAvailableLoaded) referralCampaignLoaded = await _getRunningReferralCampaignUsecase.run();
      },
    );
    await hideLoading();
    if (isSuccess) {
      _user.value = null;
      _user.value = userLoaded;
      _isReferralAvailable.value = isReferralAvailableLoaded;
      _referralCampaign.value = referralCampaignLoaded;
    }

    return isSuccess;
  }

  bool isReferralCampaignAvaiable() {
    return _isReferralAvailable.value && _referralCampaign.value != null;
  }
}
