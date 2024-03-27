import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/remote_image_resize_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaign_detail/charity_campaign_detail_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaign_detail/widgets/charity_donation_list_view_item.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaign_detail/widgets/charity_webview_with_size.dart';
import 'package:santapocket/modules/charity/app/ui/charity_donors/charity_donors_page.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CharityCampaignDetailPage extends StatefulWidget {
  final String charityCampaignId;

  const CharityCampaignDetailPage({super.key, required this.charityCampaignId});

  @override
  State<CharityCampaignDetailPage> createState() => _CharityCampaignDetailPageState();
}

class _CharityCampaignDetailPageState extends BaseViewState<CharityCampaignDetailPage, CharityCampaignDetailPageViewModel> {
  int currentPage = 0;

  @override
  CharityCampaignDetailPageViewModel createViewModel() => locator<CharityCampaignDetailPageViewModel>();

  @override
  void loadArguments() {
    viewModel.charityCampaignId = widget.charityCampaignId;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.pearchBurst,
        centerTitle: true,
        title: Text(LocaleKeys.charity_campaigns_details.trans().toUpperCase(), style: AppTheme.black_16w600),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Obx(
            () => Visibility(
              visible: viewModel.helpCenterUrl.isNotEmpty,
              child: GestureDetector(
                onTap: () => Get.to(() => WebViewPage(url: viewModel.helpCenterUrl)),
                child: Assets.icons.icReferralQuestionMark.image(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.refreshCharities,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Obx(() {
                          if (viewModel.charityCampaignImages.isNotEmpty) {
                            return SizedBox(
                              height: 208.h,
                              width: double.infinity,
                              child: Swiper(
                                loop: viewModel.charityCampaignImages.length > 1,
                                itemCount: viewModel.charityCampaignImages.length,
                                autoplay: false,
                                onIndexChanged: (index) {
                                  setState(() {
                                    currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: RemoteImageResizeHelper.getImageResize(
                                      viewModel.charityCampaignImages[index].url,
                                      0,
                                      208.h * MediaQuery.of(context).devicePixelRatio,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Assets.images.imgCharityDefaultDetail.image(height: 208.h, width: double.infinity, fit: BoxFit.cover);
                        }),
                        Obx(
                          () => Visibility(
                            visible: viewModel.charityCampaignImages.length > 1,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: viewModel.charityCampaignImages.asMap().entries.map((e) {
                                  return Container(
                                    width: 8.w,
                                    height: 8.w,
                                    margin: EdgeInsets.only(
                                      left: 4.w,
                                      right: 4.w,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentPage == e.key ? AppTheme.orange.withOpacity(0.8) : AppTheme.grey.withOpacity(0.5),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          viewModel.charityCampaign?.name ?? "",
                          style: AppTheme.blackDark_18w600,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Text(
                        LocaleKeys.charity_cooperation.trans(),
                        style: AppTheme.blackDark_16w600,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 25,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              height: 46.h,
                              decoration: BoxDecoration(
                                color: AppTheme.antiFlashWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Assets.images.imgAppWithoutSlogan.image(),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            flex: 75,
                            child: LayoutBuilder(
                              builder: (context, constraints) => Row(
                                children: [
                                  Container(
                                    height: 46.h,
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme.antiFlashWhite,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Obx(
                                      () => Row(
                                        children: [
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          viewModel.charityCampaign?.charity?.iconUrl != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(38.h),
                                                  child: Image.network(
                                                    viewModel.charityCampaign?.charity?.iconUrl ?? "",
                                                    width: 38.h,
                                                    height: 38.h,
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : Assets.icons.icCharityOrgDefaultIcon.image(
                                                  width: 38.h,
                                                  height: 38.h,
                                                ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: constraints.maxWidth - 50.w, minWidth: 20.w),
                                            child: Container(
                                              color: AppTheme.antiFlashWhite,
                                              child: Text(
                                                viewModel.charityCampaign?.charity?.name ?? "",
                                                style: AppTheme.blackDark_14w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
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
                        height: 5.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.charity_campaign_overview.trans(),
                            style: AppTheme.blackDark_16w600,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Obx(
                            () => Visibility(
                              visible: viewModel.isShouldGiftType,
                              child: Column(
                                children: [
                                  EasyRichText(
                                    "${LocaleKeys.charity_donation_items.trans()}: ${viewModel.charityCampaign?.giftType ?? ""}",
                                    defaultStyle: AppTheme.black_14w400,
                                    patternList: [
                                      EasyRichTextPattern(
                                        targetString: LocaleKeys.charity_donation_items.trans(),
                                        style: AppTheme.black_14w600,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: viewModel.isShouldCharityBeneficiary,
                              child: Column(
                                children: [
                                  EasyRichText(
                                    "${LocaleKeys.charity_beneficiary.trans()}: ${viewModel.charityCampaign?.beneficiary ?? ""}",
                                    defaultStyle: AppTheme.black_14w400,
                                    patternList: [
                                      EasyRichTextPattern(
                                        targetString: LocaleKeys.charity_beneficiary.trans(),
                                        style: AppTheme.black_14w600,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => EasyRichText(
                              "${LocaleKeys.charity_time_to_donate.trans()}: ${FormatHelper.formatDate("dd/MM/yyyy", viewModel.charityCampaign?.startedAt)} - ${FormatHelper.formatDate("dd/MM/yyyy", viewModel.charityCampaign?.endedAt)}",
                              defaultStyle: AppTheme.black_14w400,
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: LocaleKeys.charity_time_to_donate.trans(),
                                  style: AppTheme.black_14w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: (viewModel.charityCampaign?.infoUrl ?? "").isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              child: Container(
                                color: AppTheme.superSilver,
                                width: double.infinity,
                                height: 5.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Text(
                                LocaleKeys.charity_campaign_info.trans(),
                                style: AppTheme.blackDark_16w600,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Stack(children: [
                                CharityWebViewWithSize(height: 400.h, width: double.infinity, url: viewModel.charityCampaign?.infoUrl ?? ""),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 415.h,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(color: AppTheme.yellow1),
                                      color: AppTheme.white,
                                    ),
                                    width: double.infinity,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 14.5.h),
                                        elevation: 0,
                                      ),
                                      onPressed: () => Get.to(() => WebViewPage(url: viewModel.charityCampaign?.infoUrl ?? "")),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            LocaleKeys.charity_see_detail.trans(),
                                            style: AppTheme.yellow1_14w600,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Assets.icons.icDoubleArrow.image(width: 12.w, height: 12.h, fit: BoxFit.cover),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => Visibility(
                        visible: viewModel.charityDonors.isNotEmpty,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              child: Container(
                                color: AppTheme.superSilver,
                                width: double.infinity,
                                height: 5.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        LocaleKeys.charity_charitable_donors.trans(),
                                        style: AppTheme.blackDark_16w600,
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => Get.to(() => CharityDonorsPage(
                                              charityCampaignId: viewModel.charityCampaignId,
                                            )),
                                        child: Text(LocaleKeys.charity_view_all.trans(), style: AppTheme.yellow1_14w400),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Obx(
                              () => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      CharityDonationListViewItem(charityDonation: viewModel.charityDonors.elementAt(index)),
                                  itemCount: viewModel.charityDonors.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: viewModel.isDonatable,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: AppTheme.red,
                ),
                width: double.infinity,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.5.h),
                    elevation: 0,
                  ),
                  onPressed: () => viewModel.onDonateNowClickButton(),
                  child: Text(
                    LocaleKeys.charity_donate_now.trans(),
                    style: AppTheme.white_14w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
