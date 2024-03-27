import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/app/ui/login/enter_phone_page_viewmodel.dart';
import 'package:santapocket/modules/auth/app/ui/login/widgets/send_otp_method_radio_item.dart';
import 'package:santapocket/shared/listview/no_glowing_scroll_behavior.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class EnterPhonePage extends StatefulWidget {
  static const int smsMethod = 0;
  static const int voiceCallMethod = 1;
  static const int zaloMethod = 2;
  static const int emailMethod = 3;

  const EnterPhonePage({Key? key}) : super(key: key);

  @override
  State<EnterPhonePage> createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends BaseViewState<EnterPhonePage, EnterPhonePageViewModel> with WidgetsBindingObserver {
  @override
  EnterPhonePageViewModel createViewModel() => locator<EnterPhonePageViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viewModel.setLanguage(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      viewModel.onResumeApp();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneField = TextField(
      focusNode: viewModel.phoneNode,
      scrollPadding: EdgeInsets.only(bottom: 120.h),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        isDense: true,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: LocaleKeys.auth_enter_phone_description.trans(),
        hintStyle: AppTheme.greyText_14w400,
      ),
      textAlign: TextAlign.left,
      keyboardType: TextInputType.phone,
      controller: viewModel.phoneController,
    );

    Widget loginButton(EnterPhonePageViewModel viewModel) => SizedBox(
          width: double.infinity,
          child: TapDebouncer(
            onTap: () async {
              context.hideKeyboard();
              await viewModel.loginViaPhone();
            },
            builder: (BuildContext context, TapDebouncerFunc? onTap) => Obx(() => TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    backgroundColor:
                        (!viewModel.isOTPFocus && !viewModel.isPhoneFocus && viewModel.isValidOTP && viewModel.isValidPhone && viewModel.isAcceptTos)
                            ? AppTheme.orange
                            : AppTheme.orangeBlur.withOpacity(0.4),
                  ),
                  onPressed:
                      (!viewModel.isOTPFocus && !viewModel.isPhoneFocus && viewModel.isValidOTP && viewModel.isValidPhone && viewModel.isAcceptTos)
                          ? onTap
                          : null,
                  child: Text(
                    LocaleKeys.auth_sign_in.trans(),
                    style: AppTheme.white_14w600,
                  ),
                )),
          ),
        );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          Container(
            color: AppTheme.gluttonyOrange,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 65.h),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18.w),
                      child: Container(
                        height: 100.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.only(top: 17.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r)),
                          color: Colors.white,
                        ),
                        child: ScrollConfiguration(
                          behavior: NoGlowingScrollBehavior(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Assets.images.imgAppWithoutSlogan.image(
                                  width: 187.w,
                                  height: 80.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 39.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.auth_sign_in.trans(),
                                    style: AppTheme.blackDark_25w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                                Text(
                                  LocaleKeys.auth_please_enter_phone_number.trans(),
                                  style: AppTheme.blackDark_14w600,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.auth_enter_phone_description.trans().toLowerCase().capitalizeFirst ?? '',
                                    style: AppTheme.neutral_14w600,
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    margin: EdgeInsets.symmetric(vertical: 4.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.sp,
                                        color: viewModel.isPhoneFocus
                                            ? AppTheme.gluttonyOrange
                                            : viewModel.showPhoneError
                                                ? AppTheme.ferociousOrange
                                                : AppTheme.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => viewModel.navigateToCountryPage(),
                                          child: Container(
                                            height: 45.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12.r),
                                                topLeft: Radius.circular(12.r),
                                              ),
                                              color: AppTheme.apricotIceOrange,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 10.h,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    viewModel.currentCountryPhoneCode,
                                                    style: AppTheme.black_16,
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Assets.icons.icFilterArrowDown.image(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 47.h,
                                            alignment: Alignment.centerLeft,
                                            child: phoneField,
                                          ),
                                        ),
                                        Obx(() => Visibility(
                                              visible: viewModel.showPhoneClearIcon,
                                              child: GestureDetector(
                                                onTap: () => viewModel.phoneController.clear(),
                                                child: Padding(
                                                  padding: EdgeInsets.only(right: 16.w),
                                                  child: Assets.icons.icCloseLightGrey.image(),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.auth_send_verification_code_decription.trans(),
                                    style: AppTheme.grey_14w400,
                                  ),
                                ),
                                Obx(
                                  () => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Visibility(
                                      visible: viewModel.showPhoneError,
                                      child: Text(
                                        LocaleKeys.auth_invalid_phone_message.trans(),
                                        style: AppTheme.ferociousOrange_13w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.h, bottom: 4.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => SendOTPMethodRadioItem(
                                          label: "Zalo",
                                          isSelected: viewModel.sendOTPMethod == EnterPhonePage.zaloMethod,
                                          value: EnterPhonePage.zaloMethod,
                                          onSelectItem: (val) => viewModel.setSendOTPMethod(val ?? EnterPhonePage.zaloMethod),
                                        ),
                                      ),
                                      Obx(
                                        () => SendOTPMethodRadioItem(
                                          label: "SMS",
                                          isSelected: viewModel.sendOTPMethod == EnterPhonePage.smsMethod,
                                          value: EnterPhonePage.smsMethod,
                                          onSelectItem: (val) => viewModel.setSendOTPMethod(val ?? EnterPhonePage.smsMethod),
                                        ),
                                      ),
                                      Obx(
                                        () => SendOTPMethodRadioItem(
                                          label: "${LocaleKeys.auth_voice_call.trans()} (*)",
                                          isSelected: viewModel.sendOTPMethod == EnterPhonePage.voiceCallMethod,
                                          value: EnterPhonePage.voiceCallMethod,
                                          onSelectItem: (val) => viewModel.setSendOTPMethod(val ?? EnterPhonePage.voiceCallMethod),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "(*) ${LocaleKeys.auth_voice_call_only_message.trans()}",
                                      style: viewModel.sendOTPMethod != EnterPhonePage.voiceCallMethod
                                          ? AppTheme.grey_14w400
                                          : AppTheme.goldishOrange_14w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.auth_verification_code.trans(),
                                    style: AppTheme.neutral_14w600,
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    margin: EdgeInsets.symmetric(vertical: 4.h),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.sp,
                                        color: viewModel.isOTPFocus
                                            ? AppTheme.gluttonyOrange
                                            : viewModel.showOTPError
                                                ? AppTheme.ferociousOrange
                                                : AppTheme.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            focusNode: viewModel.otpNode,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 13.h,
                                              ),
                                              hintText: LocaleKeys.auth_enter_6_digit_code.trans(),
                                              hintStyle: AppTheme.lightBorder_14,
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
                                              child: Text(
                                                viewModel.countDown > 0
                                                    ? LocaleKeys.auth_resend_in.trans(namedArgs: {"second": "${viewModel.countDown}"})
                                                    : LocaleKeys.auth_get_code.trans(),
                                                style: viewModel.countDown > 0 ? AppTheme.lightBorder_14w700 : AppTheme.yellow1_14w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Visibility(
                                      visible: viewModel.showOTPError,
                                      child: Text(
                                        LocaleKeys.auth_invalid_otp_message.trans(),
                                        style: AppTheme.ferociousOrange_13w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w).copyWith(top: 2.h),
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
                                        LocaleKeys.auth_term_and_condition_description.trans(),
                                        defaultStyle: AppTheme.blackDark_14.copyWith(height: 1.25.h),
                                        patternList: [
                                          EasyRichTextPattern(
                                            targetString: LocaleKeys.auth_terms_conditions_agreement.trans(),
                                            style: AppTheme.gluttonyOrange_14,
                                            recognizer: TapGestureRecognizer()..onTap = viewModel.launchTermsAndConditionsUrl,
                                          ),
                                          EasyRichTextPattern(
                                            targetString: LocaleKeys.auth_privacy_policy.trans(),
                                            style: AppTheme.gluttonyOrange_14,
                                            recognizer: TapGestureRecognizer()..onTap = viewModel.launchPrivacyPolicyUrl,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.h),
                                  child: loginButton(viewModel),
                                ),
                                GestureDetector(
                                  onTap: () => viewModel.onLanguageClicked(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Assets.icons.icLanguageYellow.image(),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        LocaleKeys.auth_language_reverse.trans(),
                                        style: AppTheme.goldishOrange_14,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
