import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/cabinet_not_found_widget.dart';
import 'package:santapocket/modules/charity/app/ui/charity_history/charity_delivery_history_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/charity_history/widgets/charity_delivery_history_list_view.dart';
import 'package:santapocket/modules/charity/app/ui/charity_history/widgets/empty_charity_deliveries_page.dart';
import 'package:santapocket/modules/delivery/app/ui/history/filter/filter_page.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CharityDeliveryHistoryPage extends StatefulWidget {
  const CharityDeliveryHistoryPage({Key? key}) : super(key: key);

  @override
  State<CharityDeliveryHistoryPage> createState() => _DeliveryHistoryPageState();
}

class _DeliveryHistoryPageState extends BaseViewState<CharityDeliveryHistoryPage, CharityDeliveryHistoryPageViewModel>
    with AutomaticKeepAliveClientMixin {
  @override
  CharityDeliveryHistoryPageViewModel createViewModel() => locator<CharityDeliveryHistoryPageViewModel>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Row(
              children: [
                Obx(
                  () => Expanded(
                    child: DebounceTextfield(
                      action: (text) => viewModel.onSearch(),
                      controller: viewModel.searchTextController,
                      duration: const Duration(milliseconds: 1000),
                      onTextfieldEmpty: () => viewModel.onRefresh(),
                      textFieldStyle: AppTheme.blackDark_14w400,
                      inputDecoration: InputDecoration(
                        hintText: LocaleKeys.charity_search_delivery.trans(),
                        hintStyle: AppTheme.grey_14w400,
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        prefixIcon: Assets.icons.icSearch.image(
                          width: 20.w,
                          height: 20.h,
                        ),
                        suffixIcon: viewModel.isCanClearSearch
                            ? TapDebouncer(
                                onTap: () async {
                                  context.hideKeyboard();
                                  await viewModel.onClearSearch();
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
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.w),
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
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: InkWell(
                    onTap: () => Get.to(
                      () => FilterPage(
                        selectedPeriod: viewModel.filterPeriod,
                        selectedCabinet: viewModel.filterCabinet,
                        onApplyFilter: viewModel.onApplyFilter,
                        isCharity: true,
                      ),
                    ),
                    child: SizedBox(
                      width: 30.w,
                      height: 30.h,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Assets.icons.icFilter.image(width: 23.w, height: 23.w),
                          Obx(
                            () => Visibility(
                              visible: viewModel.filterAppliedCount != 0,
                              child: Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 14.w,
                                  height: 14.w,
                                  decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(20.w)),
                                  child: Center(
                                    child: Text(
                                      "${viewModel.filterAppliedCount}",
                                      style: AppTheme.white_12,
                                    ),
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
          ),
          Obx(() => Row(
                children: [
                  ..._buildFilterTab(viewModel.tabIndex, (index) {
                    viewModel.onChangeTap(index);
                  }),
                ],
              )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.onRefresh,
              child: Obx(
                () => viewModel.deliveries.isNotEmpty
                    ? CharityDeliveryHistoryListView(
                        scrollController: viewModel.scrollController,
                        deliveries: viewModel.deliveries,
                        isLoadMoreEnable: viewModel.canLoadMore,
                        userId: viewModel.getUserId,
                        onLoadMore: () {
                          viewModel.fetchDataDeliveries(isShouldShowLoading: false);
                        },
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: viewModel.searchTextController.text.isNotEmpty ? const CabinetNotFoundWidget() : const EmptyCharityDeliveriesPage(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterTab(int selectedTab, Function(int index) onTap) {
    return List.generate(3, (index) {
      String label = LocaleKeys.charity_all.trans();
      switch (index) {
        case 0:
          label = LocaleKeys.charity_all.trans();
          break;
        case 1:
          label = LocaleKeys.charity_processing.trans();
          break;
        case 2:
          label = LocaleKeys.charity_finished.trans();
          break;
      }
      return Expanded(
        child: InkWell(
          onTap: () {
            if (index != selectedTab) {
              onTap(index);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selectedTab == index ? AppTheme.orange : AppTheme.line2,
                  width: 2.h,
                ),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: selectedTab == index ? AppTheme.orange_14w600 : AppTheme.grey_14w600,
              ),
            ),
          ),
        ),
      );
    });
  }
}
