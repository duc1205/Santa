import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/referral_campaign/app/ui/insert_code/referral_insert_code_page_viewmodel.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class ReferralInsertCodePage extends StatefulWidget {
  final bool isFromRegistration;
  final ReferralCampaign? referralCampaign;
  final Function()? callback;
  const ReferralInsertCodePage({super.key, required this.isFromRegistration, required this.referralCampaign, this.callback});

  @override
  State<ReferralInsertCodePage> createState() => _ReferralInsertCodePageState();
}

class _ReferralInsertCodePageState extends BaseViewState<ReferralInsertCodePage, ReferralInsertCodePageViewModel> {
  @override
  ReferralInsertCodePageViewModel createViewModel() => locator<ReferralInsertCodePageViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.loadReferralCampaign(widget.referralCampaign);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: widget.isFromRegistration ? AppTheme.gluttonyOrange : Colors.white,
          leading: widget.isFromRegistration
              ? null
              : GestureDetector(
                  onTap: () {
                    if (widget.callback != null) widget.callback!();
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back),
                ),
          actions: [
            GestureDetector(
              onTap: () => viewModel.launchReferralCampaignUri(),
              child: Assets.icons.icReferralQuestionMark.image(
                color: widget.isFromRegistration ? Colors.white : Colors.black,
              ),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            LocaleKeys.referral_campaign_insert_code_title.trans().toUpperCase(),
            style: widget.isFromRegistration ? AppTheme.white_16w600 : AppTheme.black_16w600,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Align(alignment: Alignment.center, child: Assets.icons.icReferralRedPresentOpened.image()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    padding: EdgeInsets.all(14.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightBorder.withOpacity(0.125),
                          spreadRadius: 3,
                          blurRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.referral_campaign_insert_code_message.trans(),
                          style: AppTheme.grey1_14w600,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.sp, color: viewModel.isCodeFocus ? AppTheme.gluttonyOrange : AppTheme.greyText),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: viewModel.codeController,
                                    focusNode: viewModel.codeNode,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: LocaleKeys.referral_campaign_insert_code_hint.trans(),
                                      hintStyle: AppTheme.lightBorder_14,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    style: AppTheme.blackDark_14w400,
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: viewModel.showPhoneClearIcon,
                                    child: GestureDetector(
                                      onTap: () => viewModel.codeController.clear(),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.w),
                                        child: Assets.icons.icCloseLightGrey.image(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Visibility(
                          visible: viewModel.referralCampaign?.descriptions?.isNotEmpty ?? false,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: viewModel.referralCampaign?.descriptions?.length,
                            itemBuilder: (context, index) => Visibility(
                              visible: (viewModel.referralCampaign?.descriptions?[index] ?? "").isNotEmpty,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: AppTheme.green, size: 16.sp),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  SizedBox(
                                    width: 287.w,
                                    child: Text(
                                      viewModel.referralCampaign?.descriptions?[index] ?? "",
                                      style: AppTheme.neutral_12w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 120.h,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Obx(
                          () => Container(
                            height: 50.h,
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                            child: SizedBox.expand(
                              child: TextButton(
                                onPressed: viewModel.showPhoneClearIcon ? viewModel.applyVerify : null,
                                style: TextButton.styleFrom(
                                  backgroundColor: viewModel.showPhoneClearIcon ? AppTheme.gluttonyOrange : AppTheme.yellow4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    LocaleKeys.referral_campaign_apply.trans(),
                                    style: AppTheme.white_16w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Visibility(
                          visible: widget.isFromRegistration,
                          child: Container(
                            height: 50.h,
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow, width: 1.w),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: SizedBox.expand(
                              child: TextButton(
                                onPressed: () => viewModel.navigateToHomePage(),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppTheme.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    LocaleKeys.referral_campaign_skip.trans(),
                                    style: AppTheme.yellow1_14w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
