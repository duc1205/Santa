import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/delivery/app/ui/history/filter/filter_cabinets/filter_cabinets_page.dart';
import 'package:santapocket/modules/delivery/app/ui/history/filter/filter_page_view_model.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class FilterPage extends StatefulWidget {
  final DatePeriod? selectedPeriod;
  final Cabinet? selectedCabinet;
  final bool isCharity;
  final Function(DatePeriod?, Cabinet?) onApplyFilter;

  const FilterPage({
    Key? key,
    required this.onApplyFilter,
    required this.selectedPeriod,
    required this.selectedCabinet,
    this.isCharity = false,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends BaseViewState<FilterPage, FilterPageViewModel> {
  @override
  FilterPageViewModel createViewModel() => locator<FilterPageViewModel>();

  @override
  void loadArguments() {
    viewModel.onChangeDateRange(widget.selectedPeriod);
    viewModel.onChangeCabinet(widget.selectedCabinet);
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
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
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
            Obx(
              () => Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppTheme.linghDarkPink,
                  border: viewModel.filterPeriod != null ? Border.all(color: AppTheme.orange) : null,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: viewModel.showDialogDateTimeRange,
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.orange),
                        child: Image.asset(
                          Assets.icons.icFilterCalendar.path,
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: Text(
                          viewModel.filterPeriod != null ? viewModel.getFilterPeriodString : LocaleKeys.delivery_date.trans(),
                          style: AppTheme.black_14,
                        ),
                      ),
                      Visibility(
                        visible: viewModel.filterPeriod != null,
                        child: InkWell(
                          onTap: viewModel.onClearPeriodFilter,
                          child: Icon(
                            Icons.clear,
                            size: 20.sp,
                            color: AppTheme.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppTheme.linghDarkPink,
                  border: viewModel.filterCabinet != null ? Border.all(color: AppTheme.orange) : null,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.to(() => FilterCabinetsPage(
                        onConfirm: viewModel.onChangeCabinetFilter,
                        selectedCabinet: viewModel.filterCabinet,
                        isCharity: widget.isCharity,
                      )),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.red),
                        child: Image.asset(
                          Assets.icons.icBottomBarCabinet.path,
                          width: 20.w,
                          height: 20.h,
                          color: AppTheme.white,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: viewModel.filterCabinet != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.filterCabinet!.name,
                                    style: AppTheme.blackDark_16w600,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Text("${viewModel.filterCabinet?.location?.address}"),
                                  ),
                                ],
                              )
                            : Text(
                                LocaleKeys.delivery_cabinets.trans(),
                                style: AppTheme.black_14,
                              ),
                      ),
                      Visibility(
                        visible: viewModel.filterCabinet != null,
                        child: InkWell(
                          onTap: viewModel.onClearCabinetFilter,
                          child: Icon(
                            Icons.clear,
                            size: 20.sp,
                            color: AppTheme.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => TextButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        backgroundColor: AppTheme.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          side: BorderSide(
                            color: viewModel.canClearAll() ? AppTheme.orange : AppTheme.orange.withOpacity(0.3),
                          ),
                        ),
                      ),
                      onPressed: viewModel.canClearAll() ? viewModel.onClearAll : null,
                      child: Text(
                        LocaleKeys.delivery_clear_all.trans(),
                        style: AppTheme.orange_14w600.copyWith(color: viewModel.canClearAll() ? AppTheme.orange : AppTheme.orange.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      backgroundColor: AppTheme.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      widget.onApplyFilter(viewModel.filterPeriod, viewModel.filterCabinet);
                    },
                    child: Text(
                      LocaleKeys.delivery_apply.trans(),
                      style: AppTheme.white_14w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
