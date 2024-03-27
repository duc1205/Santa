import 'dart:io';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/hrm_payroll_register_page.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class HrmPayrollInfoPageViewmodel extends AppViewModel {
  final GetSettingUsecase _getSettingUsecase;

  HrmPayrollInfoPageViewmodel(
    this._getSettingUsecase,
  );

  String termsAndConditionsUrl = '';

  late Language language;

  @override
  void initState() {
    _getTOSLink();
    super.initState();
  }

  void launchTermsAndConditionsUrl() => launchUri(termsAndConditionsUrl);

  Future<Unit> _getTOSLink() async {
    await showLoading();
    final locale = language != Language.unknown ? language.getValue() : FormatHelper.getPlatformLocaleName();
    String termsAndConditionsUrlVi = "";
    String termsAndConditionsUrlEn = "";

    await run(() async {
      termsAndConditionsUrlVi = (await _getSettingUsecase.run(Constants.payrollPrivacyPolicyUrlVi)).value ?? '';
      termsAndConditionsUrlEn = (await _getSettingUsecase.run(Constants.payrollPrivacyPolicyUrlEn)).value ?? '';
    });
    await hideLoading();
    if (termsAndConditionsUrlVi.isEmpty && termsAndConditionsUrlEn.isEmpty) {
      return unit;
    }
    //Display correct language VI = VI , EN = EN
    //If you only add the VI link, it will display both languages
    //If you only add the EN link, only EN will be displayed
    termsAndConditionsUrl = termsAndConditionsUrlVi.isEmpty && locale == (Language.en.getValue())
        ? termsAndConditionsUrlEn
        : termsAndConditionsUrlVi.isNotEmpty
            ? termsAndConditionsUrlVi
            : locale == (Language.vi.getValue())
                ? termsAndConditionsUrlVi
                : termsAndConditionsUrlEn;
    return unit;
  }

  Unit onContinueClicked() {
    Get.to(() => HrmPayrollRegisterPage(
          language: language,
        ));
    return unit;
  }
}
