import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaign_detail/widgets/charity_donation_list_view_item.dart';
import 'package:santapocket/modules/charity/app/ui/charity_donors/charity_donors_page_viewmodel.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CharityDonorsPage extends StatefulWidget {
  final String charityCampaignId;
  const CharityDonorsPage({super.key, required this.charityCampaignId});

  @override
  State<CharityDonorsPage> createState() => _CharityDonorsPageState();
}

class _CharityDonorsPageState extends BaseViewState<CharityDonorsPage, CharityDonorsPageViewModel> {
  @override
  CharityDonorsPageViewModel createViewModel() => locator<CharityDonorsPageViewModel>();

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
        title: Text(LocaleKeys.charity_charitable_donors.trans().toUpperCase(), style: AppTheme.black_16w600),
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
                  hintText: LocaleKeys.charity_search_charitable_donors.trans(),
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
          Obx(
            () => viewModel.charityDonors.isEmpty && viewModel.isEmptyList
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
                : viewModel.charityDonors.isEmpty && viewModel.isEmptySearch
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
                        child: RefreshIndicator(
                          onRefresh: () => viewModel.refreshCharities(),
                          child: Padding(
                            padding: EdgeInsets.all(15.sp),
                            child: CustomScrollView(
                              controller: viewModel.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: viewModel.charityDonors.length,
                                    (context, index) => CharityDonationListViewItem(charityDonation: viewModel.charityDonors.elementAt(index)),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: viewModel.isLoadingMore ? const LoadMoreView() : Container(),
                                ),
                              ],
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
