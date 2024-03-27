import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filter_district/filter_districts_page_view_model.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filter_district/widgets/filter_district_listview_item.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/cabinet_not_found_widget.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class FilterDistrictsPage extends StatefulWidget {
  final String selectedDistrict;
  final String selectedCity;
  final Function(String) onConfirm;

  const FilterDistrictsPage({
    Key? key,
    required this.selectedDistrict,
    required this.selectedCity,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<FilterDistrictsPage> createState() => _FilterDistrictsPageState();
}

class _FilterDistrictsPageState extends BaseViewState<FilterDistrictsPage, FilterDistrictsPageViewModel> {
  @override
  FilterDistrictsPageViewModel createViewModel() => locator<FilterDistrictsPageViewModel>();

  @override
  void loadArguments() {
    viewModel.setSelectedDistrict(widget.selectedDistrict);
    viewModel.selectedCity = widget.selectedCity;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "City".toUpperCase(),
          style: AppTheme.black_16w600,
        ),
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => EasyListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                scrollbarEnable: false,
                itemCount: viewModel.districts.length,
                itemBuilder: (context, index) {
                  final district = viewModel.districts[index];
                  return Obx(() => InkWell(
                        onTap: () => viewModel.setSelectedDistrict(district),
                        child: FilterDistrictListViewItem(
                          city: viewModel.districts[index],
                          isSelected: viewModel.selectedDistrict == district,
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
                widget.onConfirm(viewModel.selectedDistrict);
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
