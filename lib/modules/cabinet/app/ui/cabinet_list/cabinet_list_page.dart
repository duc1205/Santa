import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/cabinet_list_page_viewmodel.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filter_cabinet_page.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/cabinet_item.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/cabinet_not_found_widget.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/empty_cabinet_page.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CabinetListPage extends StatefulWidget {
  const CabinetListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CabinetListPage> createState() => _CabinetListPageState();
}

class _CabinetListPageState extends BaseViewState<CabinetListPage, CabinetListPageViewModel>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  CabinetListPageViewModel createViewModel() => locator<CabinetListPageViewModel>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      viewModel.refreshCabinets();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          LocaleKeys.cabinet_list_title.trans().toUpperCase(),
          style: AppTheme.blackDark_16w600,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppTheme.black),
        actions: [
          GestureDetector(
            onTap: () => viewModel.navigateToCabinetMapPage(),
            child: Container(
              margin: EdgeInsets.only(right: 13.w),
              child: Assets.icons.icCabinetMapLocation.image(
                width: 22.w,
                height: 22.h,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refreshCabinets,
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: DebounceTextfield(
                        action: viewModel.filterCabinets,
                        controller: viewModel.textEditingController,
                        duration: const Duration(milliseconds: 300),
                        onTextfieldEmpty: viewModel.refreshCabinets,
                        textFieldStyle: AppTheme.blackDark_14w400,
                        inputDecoration: InputDecoration(
                          hintText: LocaleKeys.cabinet_list_search.trans(),
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
                                    await viewModel.refreshCabinets();
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
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: InkWell(
                      onTap: () => Get.to(() => FilterCabinetPage(
                            selectedDistrict: viewModel.filterDistrict,
                            selectedCity: viewModel.filterCity,
                            onApplyFilter: viewModel.onApplyFilter,
                          )),
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
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: Obx(
                () => viewModel.cabinets.isNotEmpty
                    ? EasyListView(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        scrollbarEnable: false,
                        itemCount: viewModel.cabinets.length,
                        onLoadMore: viewModel.onLoadMore,
                        loadMore: viewModel.canLoadMore,
                        itemBuilder: (context, index) {
                          return CabinetItem(
                            cabinet: viewModel.cabinets[index],
                            distance: viewModel.getDistance(viewModel.cabinets[index]),
                          );
                        },
                        loadMoreItemBuilder: (context) {
                          return const LoadMoreView();
                        },
                        placeholderWidget: const CabinetNotFoundWidget(),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: viewModel.textEditingController.text.isNotEmpty ? const CabinetNotFoundWidget() : const EmptyCabinetPage(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
