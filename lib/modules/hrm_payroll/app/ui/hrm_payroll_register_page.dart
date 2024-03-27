import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/hrm_payroll_register_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class HrmPayrollRegisterPage extends StatefulWidget {
  final Language language;
  const HrmPayrollRegisterPage({super.key, required this.language});

  @override
  State<HrmPayrollRegisterPage> createState() => _HrmPayrollRegisterPageState();
}

class _HrmPayrollRegisterPageState extends BaseViewState<HrmPayrollRegisterPage, HrmPayrollRegisterPageViewmodel> {
  @override
  HrmPayrollRegisterPageViewmodel createViewModel() => locator<HrmPayrollRegisterPageViewmodel>();

  @override
  void loadArguments() {
    super.loadArguments();
    viewModel.language = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              onTap: () => viewModel.onCancelClicked(),
              child: Center(
                child: Text(
                  LocaleKeys.hrm_payroll_cancel.trans(),
                  style: AppTheme.black_16w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 272.h,
                width: double.infinity,
                child: Assets.images.imgHrmRegisterBackground.image(fit: BoxFit.cover),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.hrm_payroll_register.trans(),
                      style: AppTheme.black_20w600,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_your_email.trans(),
                      style: AppTheme.neutral_14w600,
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Obx(
                      () => TextField(
                        controller: viewModel.emailController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.hrm_payroll_enter_mail_hint.trans(),
                          hintStyle: AppTheme.grey_14w400,
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          suffixIcon: viewModel.isCanClearSearch
                              ? TapDebouncer(
                                  onTap: () async {
                                    context.hideKeyboard();
                                    viewModel.emailController.clear();
                                  },
                                  builder: (BuildContext context, TapDebouncerFunc? onTap) => IconButton(
                                    onPressed: onTap,
                                    icon: Icon(
                                      Icons.clear,
                                      size: 20.sp,
                                      color: AppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.gluttonyOrange, width: 1.w),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_send_verification_code_decription.trans(),
                      style: AppTheme.grey_13w400,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      LocaleKeys.hrm_payroll_verification_code.trans(),
                      style: AppTheme.neutral_14w600,
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding: EdgeInsets.only(right: 6.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.sp,
                          color: viewModel.isOTPFocus
                              ? AppTheme.gluttonyOrange
                              : viewModel.showOTPError
                                  ? AppTheme.ferociousOrange
                                  : Colors.grey.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: viewModel.otpNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 13.h,
                                ),
                                hintText: LocaleKeys.hrm_payroll_enter_6_digit_code.trans(),
                                hintStyle: AppTheme.grey_14w400,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.phone,
                              controller: viewModel.otpController,
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: viewModel.showOTPClearIcon,
                              child: GestureDetector(
                                onTap: () => viewModel.otpController.clear(),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Assets.icons.icCloseLightGrey.image(),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: viewModel.countDown > 0 ? null : () => viewModel.sendOTP(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 8.w,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: viewModel.countDown > 0 ? AppTheme.yellow4 : AppTheme.yellow1,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    viewModel.countDown > 0
                                        ? LocaleKeys.hrm_payroll_resend_in.trans(namedArgs: {"second": "${viewModel.countDown}"})
                                        : LocaleKeys.hrm_payroll_get_code.trans(),
                                    style: AppTheme.white_14w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: LocaleKeys.hrm_payroll_attention.trans(),
                        style: AppTheme.ferociousOrange_14w400,
                        children: [
                          TextSpan(
                            text: LocaleKeys.hrm_payroll_attention_message.trans(),
                            style: AppTheme.black_14w400,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    GestureDetector(
                      onTap: () => viewModel.launchListCompanyUrl(),
                      child: Text(
                        LocaleKeys.hrm_payroll_list_companies.trans(),
                        style: AppTheme.blueDark_12w400Underline,
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w).copyWith(top: 4.h),
                          child: SizedBox(
                            width: 14.w,
                            height: 14.w,
                            child: Obx(
                              () => Checkbox(
                                fillColor: MaterialStateProperty.resolveWith((states) {
                                  if (!states.contains(MaterialState.selected)) {
                                    return AppTheme.radioBorder;
                                  }
                                  return AppTheme.yellow1;
                                }),
                                value: viewModel.isAcceptTos,
                                onChanged: (value) => viewModel.setIsAcceptTos(value ?? false),
                                side: BorderSide(
                                  color: AppTheme.radioBorder,
                                  width: 1.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: EasyRichText(
                            LocaleKeys.hrm_payroll_policy_message.trans(),
                            defaultStyle: AppTheme.blackDark_14w400.copyWith(height: 1.25.h),
                            patternList: [
                              EasyRichTextPattern(
                                targetString: LocaleKeys.hrm_payroll_policies.trans(),
                                style: AppTheme.blueDark_14w400U,
                                recognizer: TapGestureRecognizer()..onTap = () => viewModel.launchPoliciesUrl(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 29.h,
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: viewModel.isSubmitable ? () => viewModel.onRegisterAccount() : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: viewModel.isSubmitable ? AppTheme.yellow1 : AppTheme.yellow4,
                          ),
                          child: Center(child: Text(LocaleKeys.hrm_payroll_register.trans(), style: AppTheme.white_14w600)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
