import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/cabinet_not_found_widget.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/delivery/app/ui/history/filter/filter_cabinets/filter_cabinets_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/history/widgets/filter_cabinet_listview_item.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class FilterCabinetsPage extends StatefulWidget {
  final Cabinet? selectedCabinet;
  final Function(Cabinet?) onConfirm;
  final bool isCharity;

  const FilterCabinetsPage({
    Key? key,
    required this.selectedCabinet,
    required this.onConfirm,
    this.isCharity = false,
  }) : super(key: key);

  @override
  State<FilterCabinetsPage> createState() => _FilterCabinetsPageState();
}

class _FilterCabinetsPageState extends BaseViewState<FilterCabinetsPage, FilterCabinetsViewModel> {
  @override
  FilterCabinetsViewModel createViewModel() => locator<FilterCabinetsViewModel>();

  @override
  void loadArguments() {
    viewModel.setSelectedCabinet(widget.selectedCabinet);
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.delivery_filter.trans().toUpperCase(),
          style: AppTheme.black_16w600,
        ),
        backgroundColor: widget.isCharity ? AppTheme.danger2 : Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Row(
              children: [
                Obx(
                  () => Expanded(
                    child: DebounceTextfield(
                      action: (text) => viewModel.onRefresh(),
                      controller: viewModel.searchTextController,
                      duration: const Duration(milliseconds: 1000),
                      onTextfieldEmpty: () => viewModel.onRefresh(),
                      textFieldStyle: AppTheme.blackDark_14w400,
                      inputDecoration: InputDecoration(
                        hintText: LocaleKeys.delivery_searching_for_cabinets.trans(),
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
                                  viewModel.onClearSearch();
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
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Obx(
                () => EasyListView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  scrollbarEnable: false,
                  itemCount: viewModel.cabinets.length,
                  onLoadMore: viewModel.onLoadMore,
                  loadMore: viewModel.canLoadMore,
                  itemBuilder: (context, index) {
                    final cabinet = viewModel.cabinets[index];
                    return Obx(() => InkWell(
                          onTap: () => viewModel.setSelectedCabinet(cabinet),
                          child: FilterCabinetListViewItem(
                            cabinet: viewModel.cabinets[index],
                            distance: viewModel.getDistance(viewModel.cabinets[index]),
                            isSelected: viewModel.selectedCabinet?.id == cabinet.id,
                          ),
                        ));
                  },
                  loadMoreItemBuilder: (context) {
                    return const LoadMoreView();
                  },
                  placeholderWidget: const CabinetNotFoundWidget(),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 15.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.grey.withOpacity(0.5),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.5.h),
                backgroundColor: AppTheme.orange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              onPressed: () {
                Get.back();
                widget.onConfirm(viewModel.selectedCabinet);
              },
              child: Text(
                LocaleKeys.delivery_confirm.trans(),
                style: AppTheme.white_16w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
