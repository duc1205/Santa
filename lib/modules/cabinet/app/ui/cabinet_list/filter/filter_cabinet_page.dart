import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filer_cities/filter_cities_page.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filter_cabinet_page_view_model.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filter_district/filter_districts_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class FilterCabinetPage extends StatefulWidget {
  final String selectedDistrict;
  final String selectedCity;
  final Function(String, String) onApplyFilter;

  const FilterCabinetPage({
    Key? key,
    required this.onApplyFilter,
    required this.selectedDistrict,
    required this.selectedCity,
  }) : super(key: key);

  @override
  State<FilterCabinetPage> createState() => _FilterCabinetPageState();
}

class _FilterCabinetPageState extends BaseViewState<FilterCabinetPage, FilterCabinetPageViewModel> {
  @override
  FilterCabinetPageViewModel createViewModel() => locator<FilterCabinetPageViewModel>();

  @override
  void loadArguments() {
    viewModel.onChangeDistrict(widget.selectedDistrict);
    viewModel.onChangeCity(widget.selectedCity);
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text(
          LocaleKeys.delivery_filter.trans().toUpperCase(),
          style: AppTheme.black_16w600,
        ),
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
                  color: AppTheme.shoulWhite,
                  border: viewModel.filterCity.isNotEmpty ? Border.all(color: AppTheme.orange) : null,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.to(() => FilterCitiesPage(
                        onConfirm: viewModel.onChangeCity,
                        selectedCity: viewModel.filterCity,
                      )),
                  child: Row(
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.orange,
                          border: viewModel.filterCity.isNotEmpty ? Border.all(color: AppTheme.orange) : null,
                        ),
                        child: Image.asset(
                          Assets.icons.icCabinetLocationRed.path,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: Text(
                          viewModel.filterCity.isNotEmpty ? viewModel.filterCity : LocaleKeys.delivery_city.trans(),
                          style: AppTheme.black_14,
                        ),
                      ),
                      Visibility(
                        visible: viewModel.filterCity.isNotEmpty,
                        child: InkWell(
                          onTap: viewModel.onClearAll,
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
                  color: viewModel.filterCity.isNotEmpty ? AppTheme.shoulWhite : AppTheme.shoulWhite.withOpacity(0.4),
                  border: (viewModel.filterCity.isNotEmpty && viewModel.filterDistrict.isNotEmpty) ? Border.all(color: AppTheme.orange) : null,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: viewModel.filterCity.isNotEmpty
                      ? () => Get.to(() => FilterDistrictsPage(
                            onConfirm: viewModel.onChangeDistrict,
                            selectedCity: viewModel.filterCity,
                            selectedDistrict: viewModel.filterDistrict,
                          ))
                      : null,
                  child: Row(
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: viewModel.filterCity.isNotEmpty ? AppTheme.red : AppTheme.red.withOpacity(0.4),
                        ),
                        child: Image.asset(
                          Assets.icons.icCabinetLocationRed.path,
                          color: viewModel.filterCity.isNotEmpty ? Colors.white : Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: Text(
                          viewModel.filterDistrict.isNotEmpty ? viewModel.filterDistrict : LocaleKeys.delivery_district.trans(),
                          style: viewModel.filterCity.isNotEmpty ? AppTheme.black_14 : AppTheme.grey1_14w400,
                        ),
                      ),
                      Visibility(
                        visible: viewModel.filterDistrict.isNotEmpty,
                        child: InkWell(
                          onTap: viewModel.onClearDistrictFilter,
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
                      onPressed: viewModel.onClearAll,
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
                      widget.onApplyFilter(viewModel.filterCity, viewModel.filterDistrict);
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
