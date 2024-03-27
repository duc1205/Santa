import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/modules/main/app/ui/main_page.dart';
import 'package:santapocket/modules/referral_campaign/app/ui/insert_code/result_pages/referral_insert_code_success_page.dart';
import 'package:santapocket/modules/referral_campaign/app/ui/insert_code/widgets/insert_code_fail_dialog_widget.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:santapocket/modules/referral_campaign/domain/usecases/verify_referral_code_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReferralInsertCodePageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final VerifyReferralCodeUsecase _verifyReferralCodeUsecase;

  String errorMessage = "";
  bool isShowPopup = false;

  final TextEditingController codeController = TextEditingController();
  final codeNode = FocusNode();

  final _isCodeFocus = false.obs;
  final _showPhoneClearIcon = false.obs;
  final _user = Rx<User?>(null);
  final _referralCampaign = Rx<ReferralCampaign?>(null);

  User? get user => _user.value;

  bool get isCodeFocus => _isCodeFocus.value;

  bool get showPhoneClearIcon => _showPhoneClearIcon.value;

  ReferralCampaign? get referralCampaign => _referralCampaign.value;

  ReferralInsertCodePageViewModel(
    this._getProfileUsecase,
    this._verifyReferralCodeUsecase,
  );

  @override
  void initState() {
    _initListener();
    _fetchData();
    super.initState();
  }

  @override
  Future<Unit> handleError(dynamic error) async {
    if (error is RestError) {
      final errorCode = error.getHeader(Constants.errorCodeResponseHeader);
      if (errorCode == "7001" || errorCode == "7002") {
        errorMessage = error.getAllErrorWithString();
        isShowPopup = true;
        return unit;
      }
      // await handleRestError(error, errorCode);
    }
    isShowPopup = false;
    return super.handleError(error);
  }

  loadReferralCampaign(ReferralCampaign? referralCampaign) {
    _referralCampaign.value = referralCampaign;
  }

  void _initListener() {
    codeNode.addListener(() {
      if (_isCodeFocus.value != codeNode.hasFocus) {
        _isCodeFocus.value = codeNode.hasFocus;
      }
    });
    codeController.addListener(() {
      _showPhoneClearIcon.value = codeController.text.isNotEmpty;
    });
  }

  Future<bool> _fetchData() async {
    late User userLoaded;
    await showLoading();
    final isSuccess = await run(
      () async {
        userLoaded = await _getProfileUsecase.run();
      },
    );
    if (isSuccess) {
      _user.value = null;
      _user.value = userLoaded;
    }
    await hideLoading();
    return isSuccess;
  }

  Future<Unit> applyVerify() async {
    await showLoading();
    final success = await run(
      () => _verifyReferralCodeUsecase.run(
        _user.value,
        codeController.text,
      ),
    );
    await hideLoading();
    if (success) {
      await Get.offAll(() => ReferralInsertCodeSuccessPage(
            isRewared: (referralCampaign?.referredConeReward ?? 0) > 0 || (referralCampaign?.referredFreeUsageReward ?? 0) > 0,
          ));
    } else {
      if (isShowPopup) {
        await Get.dialog(
          InsertCodeFailDialogWidget(failMessage: errorMessage),
          barrierDismissible: false,
        );
      }
    }
    return unit;
  }

  navigateToSuccessPage() => Get.to(() => ReferralInsertCodeSuccessPage(
        isRewared: (referralCampaign?.referredConeReward ?? 0) > 0 || (referralCampaign?.referredFreeUsageReward ?? 0) > 0,
      ));

  navigateToHomePage() => Get.offAll(() => const MainPage());

  Unit launchReferralCampaignUri() {
    String? url = referralCampaign?.infoUrl;
    launchUri(url ?? "");
    return unit;
  }
}
