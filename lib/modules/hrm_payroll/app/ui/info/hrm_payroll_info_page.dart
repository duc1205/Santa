import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/info/hrm_payroll_info_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class HrmPayrollInfoPage extends StatefulWidget {
  final Language language;
  const HrmPayrollInfoPage({super.key, required this.language});

  @override
  State<HrmPayrollInfoPage> createState() => _HrmPayrollInfoPageState();
}

class _HrmPayrollInfoPageState extends BaseViewState<HrmPayrollInfoPage, HrmPayrollInfoPageViewmodel> {
  @override
  HrmPayrollInfoPageViewmodel createViewModel() => locator<HrmPayrollInfoPageViewmodel>();

  @override
  void loadArguments() {
    super.loadArguments();
    viewModel.language = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 280.h,
            width: double.infinity,
            child: Assets.images.imgHrmInfoBackground.image(fit: BoxFit.cover),
          ),
          SizedBox(
            height: 60.h,
          ),
          Center(
            child: Text(
              LocaleKeys.hrm_payroll_info_title.trans(),
              style: AppTheme.black_20w600,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              LocaleKeys.hrm_payroll_info_description.trans(),
              style: AppTheme.black_14w400,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Assets.icons.icHrmInfoFilePayroll.image(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_info_first_term.trans(),
                      style: AppTheme.black_14w400,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.h,
                ),
                Row(
                  children: [
                    Assets.icons.icHrmInfoPercent.image(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_info_second_term.trans(),
                      style: AppTheme.black_14w400,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.h,
                ),
                Row(
                  children: [
                    Assets.icons.icHrmInfoLink.image(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_info_third_term.trans(),
                      style: AppTheme.black_14w400,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.h,
                ),
                Row(
                  children: [
                    Assets.icons.icHrmInfoProtect.image(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_info_fourth_term.trans(),
                      style: AppTheme.black_14w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: EasyRichText(
              LocaleKeys.hrm_payroll_info_terms_and_condition.trans(),
              defaultStyle: AppTheme.blackDark_14w400,
              patternList: [
                EasyRichTextPattern(
                  targetString: LocaleKeys.hrm_payroll_here.trans(),
                  style: AppTheme.blueDark_14w400U,
                  recognizer: TapGestureRecognizer()..onTap = viewModel.launchTermsAndConditionsUrl,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GestureDetector(
              onTap: () => viewModel.onContinueClicked(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.yellow1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Center(child: Text(LocaleKeys.hrm_payroll_continue.trans(), style: AppTheme.yellow1_14w600)),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
