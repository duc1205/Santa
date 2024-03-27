import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/info/hrm_payroll_info_page.dart';
import 'package:santapocket/modules/hrm_payroll/domain/enums/payroll_status_type.dart';
import 'package:santapocket/modules/instruction/app/ui/instruction_page.dart';
import 'package:santapocket/modules/referral_campaign/app/ui/insert_code/referral_insert_code_page.dart';
import 'package:santapocket/modules/user/app/ui/app_info/app_info_page.dart';
import 'package:santapocket/modules/user/app/ui/delete_account/delete_account_page.dart';
import 'package:santapocket/modules/user/app/ui/profile/profile_page_view_model.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/profile_referral_widget.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/referral_block_widget.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/user_avatar_widget.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/transaction_history_page.dart';
import 'package:santapocket/modules/user/app/ui/user_info/user_info_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseViewState<ProfilePage, ProfilePageViewModel> with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  ProfilePageViewModel createViewModel() => locator<ProfilePageViewModel>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.silverLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.yellow1,
        elevation: 1,
        centerTitle: true,
        title: Text(
          LocaleKeys.user_profile.trans().toUpperCase(),
          style: AppTheme.blackDark_16,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => viewModel.onRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(
                () => viewModel.referralCampaign != null
                    ? ProfileReferralWidget(user: viewModel.user, shareUrl: viewModel.shareUrl)
                    : Container(
                        padding: EdgeInsets.all(15.sp),
                        color: AppTheme.yellow1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() => const UserInfoPage());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20.r)),
                            ),
                            child: Row(
                              children: [
                                UserAvatarWidget(
                                  user: viewModel.user,
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.user?.displayName ?? "",
                                        style: AppTheme.blackDark_16w600,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      Text(
                                        viewModel.user?.phoneNumber.replaceAll("+", '') ?? "",
                                        style: AppTheme.blackDark_14w400,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppTheme.grey,
                                  size: 15.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              Obx(
                () => Visibility(
                  visible: viewModel.referralCampaign != null,
                  child: ReferralBlockWidget(
                    onPressDetailButton: () => viewModel.launcReferralCampaignhUri(),
                    referralCampaign: viewModel.referralCampaign,
                    locale: viewModel.user?.locale,
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: viewModel.payrollStatus == PayrollStatusType.non_registered,
                  child: GestureDetector(
                    onTap: () => Get.to(
                      () => HrmPayrollInfoPage(language: viewModel.language),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 74.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.images.imgHrmPayrollBackground.path),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Assets.icons.icProfileHrmNoti.image(),
                          SizedBox(
                            width: 6.w,
                          ),
                          Expanded(
                            child: Text(
                              LocaleKeys.hrm_payroll_whats_new.trans(),
                              style: AppTheme.blackDark_14w700,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              border: Border.all(color: AppTheme.red1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(LocaleKeys.hrm_payroll_activate_now.trans(), style: AppTheme.red1_14w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.user_manage.trans(),
                            style: AppTheme.black_20w600,
                          ),
                          Obx(
                            () => Visibility(
                              visible: viewModel.payrollStatus != PayrollStatusType.unavailable,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => viewModel.onActivatePayrollClicked(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Assets.icons.icProfilePayroll.image(),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            LocaleKeys.hrm_payroll_santa_payroll.trans(),
                                            style: AppTheme.blackDark_14,
                                          ),
                                          const Spacer(),
                                          Assets.icons.icProfilePayrollNew.image(),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppTheme.grey,
                                            size: 15.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(
                                () => const TransactionHistoryPage(),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Assets.icons.icProfileTransactions.image(),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    LocaleKeys.user_transactions.trans(),
                                    style: AppTheme.blackDark_14,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.grey,
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: viewModel.isReferralAvailable && viewModel.referralCampaign != null,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Get.to(
                                    () => ReferralInsertCodePage(
                                      referralCampaign: viewModel.referralCampaign,
                                      isFromRegistration: false,
                                      callback: viewModel.onRefresh,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 12.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Assets.icons.icProfileInsertCode.image(),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        LocaleKeys.user_insert_referral_code.trans(),
                                        style: AppTheme.blackDark_14,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppTheme.grey,
                                        size: 15.sp,
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Container(
                        color: AppTheme.superSilver,
                        width: double.infinity,
                        height: 10.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.user_setting.trans(),
                            style: AppTheme.black_20w600,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(() => const InstructionPage());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Assets.icons.icProfileInstruction.image(),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    LocaleKeys.user_instructions.trans(),
                                    style: AppTheme.blackDark_14,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.grey,
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: viewModel.onChangeLanguage,
                            child: Obx(
                              () => Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Assets.icons.icProfileLanguage.image(),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      LocaleKeys.user_language.trans(),
                                      style: AppTheme.blackDark_14,
                                    ),
                                    const Spacer(),
                                    Text(
                                      viewModel.language.getName(),
                                      style: AppTheme.neutral_14w400,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppTheme.grey,
                                      size: 15.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(() => const AppInfoPage());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Assets.icons.icProfileInfo.image(),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    LocaleKeys.user_app_info.trans(),
                                    style: AppTheme.blackDark_14,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.grey,
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(() => const DeleteAccountPage());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Assets.icons.icProfileDeleteAccount.image(),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    LocaleKeys.user_delete_account.trans(),
                                    style: AppTheme.blackDark_14,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.grey,
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: viewModel.onLogOutClick,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Assets.icons.icProfileLogout.image(),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    LocaleKeys.user_logout.trans(),
                                    style: AppTheme.red_14,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.grey,
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: AppTheme.superSilver,
                      width: double.infinity,
                      height: 20.h,
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

  @override
  bool get wantKeepAlive => true;
}
