import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaign_detail/charity_campaign_detail_page.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaigns/charity_campaigns_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/widgets/charity_campaigns_listview_item.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CharityCampaignsPage extends StatefulWidget {
  final String charityCampaignId;
  const CharityCampaignsPage({super.key, required this.charityCampaignId});

  @override
  State<CharityCampaignsPage> createState() => _CharityCampaignsPageState();
}

class _CharityCampaignsPageState extends BaseViewState<CharityCampaignsPage, CharityCampaignsPageViewModel> {
  @override
  CharityCampaignsPageViewModel createViewModel() => locator<CharityCampaignsPageViewModel>();

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
        title: Text(LocaleKeys.charity_charity_campaigns.trans().toUpperCase(), style: AppTheme.black_16w600),
        iconTheme: const IconThemeData(color: AppTheme.blackDark),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [AppTheme.carnationBloom.withOpacity(0.3), AppTheme.white],
            stops: const [
              0.01,
              0.6,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              width: double.infinity,
              color: AppTheme.lumberOrange,
              child: Center(
                child: EasyRichText(
                  LocaleKeys.charity_choose_charity_campain.trans(),
                  defaultStyle: AppTheme.black_14w400,
                  patternList: [
                    EasyRichTextPattern(
                      targetString: '“${LocaleKeys.charity_charity_campaign.trans()}”',
                      style: AppTheme.black_14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Obx(
                () => DebounceTextfield(
                  action: viewModel.filterCabinets,
                  controller: viewModel.textEditingController,
                  duration: const Duration(milliseconds: 300),
                  onTextfieldEmpty: viewModel.refreshCharities,
                  textFieldStyle: AppTheme.blackDark_14w400,
                  inputDecoration: InputDecoration(
                    hintText: LocaleKeys.charity_search_campaign.trans(),
                    hintStyle: AppTheme.grey_14w400,
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    prefixIcon: Assets.icons.icSearch.image(
                      width: 20.w,
                      height: 20.h,
                    ),
                    suffixIcon: viewModel.query.trim().isEmpty
                        ? const SizedBox()
                        : TapDebouncer(
                            onTap: () async {
                              context.hideKeyboard();
                              await viewModel.refreshCharities();
                            },
                            builder: (BuildContext context, TapDebouncerFunc? onTap) => IconButton(
                              onPressed: onTap,
                              icon: Icon(
                                Icons.clear,
                                size: 20.sp,
                                color: AppTheme.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.gluttonyOrange, width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.w),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Obx(
              () => viewModel.charityCampaigns.isEmpty && viewModel.isEmptyList
                  ? Column(
                      children: [
                        SizedBox(
                          height: 54.h,
                        ),
                        Assets.images.imgEmptyDonation.image(),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          LocaleKeys.charity_no_charity_org.trans(),
                          style: AppTheme.blackDark_14w400,
                        ),
                      ],
                    )
                  : viewModel.charityCampaigns.isEmpty && viewModel.isEmptySearch
                      ? Column(
                          children: [
                            SizedBox(
                              height: 54.h,
                            ),
                            Assets.images.imgSearchEmpty.image(),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              LocaleKeys.charity_no_result_found.trans(),
                              style: AppTheme.blackDark_14w400,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              LocaleKeys.charity_try_different_keyword.trans(),
                              style: AppTheme.blackDark_18w600,
                            ),
                          ],
                        )
                      : Expanded(
                          child: EasyListView(
                            scrollbarEnable: false,
                            loadMore: viewModel.canLoadMore,
                            onLoadMore: () => viewModel.fetchAndSearchData(isShouldShowLoading: false),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Get.to(() => CharityCampaignDetailPage(
                                    charityCampaignId: viewModel.charityCampaigns.elementAt(index).id,
                                  )),
                              child: CharityCampaignsListViewItem(
                                charityCampaign: viewModel.charityCampaigns.elementAt(index),
                                onClickDonateNow: () => Get.to(() => CharityCampaignDetailPage(
                                      charityCampaignId: viewModel.charityCampaigns.elementAt(index).id,
                                    )),
                              ),
                            ),
                            itemCount: viewModel.charityCampaigns.length,
                            loadMoreItemBuilder: (context) {
                              return const LoadMoreView();
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
