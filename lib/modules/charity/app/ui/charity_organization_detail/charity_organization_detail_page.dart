import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaigns/charity_campaigns_page.dart';
import 'package:santapocket/modules/charity/app/ui/charity_organization_detail/charity_organization_detail_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/widgets/charity_campaigns_listview_item.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CharityOrganizationDetailPage extends StatefulWidget {
  final Charity charity;
  const CharityOrganizationDetailPage({super.key, required this.charity});

  @override
  State<CharityOrganizationDetailPage> createState() => _CharityOrganizationDetailPageState();
}

class _CharityOrganizationDetailPageState extends BaseViewState<CharityOrganizationDetailPage, CharityOrganizationDetailPageViewModel> {
  final GlobalKey _globalKey = GlobalKey();
  bool isShow = false;
  @override
  CharityOrganizationDetailPageViewModel createViewModel() => locator<CharityOrganizationDetailPageViewModel>();

  @override
  void loadArguments() {
    viewModel.setCharityId(widget.charity);
    viewModel.textPainter = TextPainter(
      maxLines: 3,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: widget.charity.description,
        style: AppTheme.blackDark_14w400,
      ),
    );
    super.loadArguments();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          isShow = (_globalKey.currentContext?.size?.height ?? 0) > 156.h;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.pearchBurst,
        centerTitle: true,
        title: Text(LocaleKeys.charity_charity_detail.trans().toUpperCase(), style: AppTheme.black_16w600),
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
      body: RefreshIndicator(
        onRefresh: () => viewModel.refreshIndicator(),
        child: CustomScrollView(
          shrinkWrap: true,
          controller: viewModel.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => viewModel.charity?.imageUrl != null
                          ? Image.network(
                              viewModel.charity?.imageUrl ?? "",
                              width: double.infinity,
                              height: 208.h,
                              fit: BoxFit.cover,
                            )
                          : Assets.images.imgCharityDefaultDetail.image(height: 208.h, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Column(
                      key: _globalKey,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Obx(
                          () => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              children: [
                                viewModel.charity?.iconUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(38.h),
                                        child: Image.network(
                                          viewModel.charity?.iconUrl ?? "",
                                          width: 38.h,
                                          height: 38.h,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : Assets.icons.icCharityOrgDefaultIcon.image(
                                        width: 38.h,
                                        height: 38.h,
                                        fit: BoxFit.fill,
                                      ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Text(
                                    viewModel.charity?.name ?? "",
                                    style: AppTheme.blackDark_18w600,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: viewModel.charity?.location?.address != null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                              child: EasyRichText(
                                "${LocaleKeys.charity_address.trans()}: ${viewModel.charity?.location?.address ?? ""}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                defaultStyle: AppTheme.blackDark_14w400,
                                patternList: [
                                  EasyRichTextPattern(
                                    targetString: LocaleKeys.charity_address.trans(),
                                    style: AppTheme.black_14w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: viewModel.charity?.description != null,
                            child: Column(
                              children: [
                                Obx(
                                  () => Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                                    child: SizedBox(
                                      height: (!viewModel.canViewMore && isShow) ? 55.h : null,
                                      child: EasyRichText(
                                        "${LocaleKeys.charity_description.trans()}: ${viewModel.charity?.description}",
                                        defaultStyle: AppTheme.blackDark_14w400,
                                        patternList: [
                                          EasyRichTextPattern(
                                            targetString: LocaleKeys.charity_description.trans(),
                                            style: AppTheme.black_14w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !isShow,
                          child: SizedBox(
                            height: 10.h,
                          ),
                        ),
                        Visibility(
                          visible: isShow,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => viewModel.setCanViewMore(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 21.h),
                                  color: AppTheme.white,
                                  width: double.infinity,
                                  child: Obx(
                                    () => Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          viewModel.canViewMore ? LocaleKeys.charity_view_less.trans() : LocaleKeys.charity_view_more.trans(),
                                          style: AppTheme.yellow1_14w600,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        viewModel.canViewMore
                                            ? Assets.icons.icCharityDoubleArrowUp.image()
                                            : Assets.icons.icCharityDoubleArrowDown.image(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      color: AppTheme.superSilver,
                      width: double.infinity,
                      height: 14.h,
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Text("${LocaleKeys.charity_running_campaign.trans()} (${viewModel.charities.length})", style: AppTheme.blackDark_16w600),
                            const Spacer(),
                            GestureDetector(
                              onTap: viewModel.charity != null
                                  ? () => Get.to(() => CharityCampaignsPage(
                                        charityCampaignId: viewModel.charity!.id,
                                      ))
                                  : () {},
                              child: Text(LocaleKeys.charity_view_all.trans(), style: AppTheme.yellow1_14w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Obx(
                      () => viewModel.charities.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 54.h,
                                  ),
                                  Assets.images.imgEmptyDonation.image(),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    LocaleKeys.charity_no_charity_campaign.trans(),
                                    style: AppTheme.blackDark_14w400,
                                  ),
                                ],
                              ),
                            )
                          : EasyListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollbarEnable: false,
                              loadMore: viewModel.canLoadMore,
                              onLoadMore: () => viewModel.fetchData(isShouldShowLoading: false),
                              itemCount: viewModel.charities.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () => viewModel.navigateToCharityCampaignDetailPage(index),
                                child: CharityCampaignsListViewItem(
                                  charityCampaign: viewModel.charities.elementAt(index),
                                  onClickDonateNow: () => viewModel.navigateToCharityCampaignDetailPage(index),
                                ),
                              ),
                              loadMoreItemBuilder: (context) {
                                return const LoadMoreView();
                              },
                            ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
