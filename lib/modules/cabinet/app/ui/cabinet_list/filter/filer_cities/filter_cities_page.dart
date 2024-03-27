import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filer_cities/filter_cities_page_view_model.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/filter/filer_cities/widgets/filter_city_listview_item.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/widget/cabinet_not_found_widget.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class FilterCitiesPage extends StatefulWidget {
  final String selectedCity;
  final Function(String) onConfirm;

  const FilterCitiesPage({
    Key? key,
    required this.selectedCity,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<FilterCitiesPage> createState() => _FilterCitiesPageState();
}

class _FilterCitiesPageState extends BaseViewState<FilterCitiesPage, FilterCitiesPageViewModel> {
  @override
  FilterCitiesPageViewModel createViewModel() => locator<FilterCitiesPageViewModel>();

  @override
  void loadArguments() {
    viewModel.setSelectedCity(widget.selectedCity);
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
                itemCount: viewModel.cities.length,
                itemBuilder: (context, index) {
                  final city = viewModel.cities[index];
                  return Obx(() => InkWell(
                        onTap: () => viewModel.setSelectedCity(city),
                        child: FilterCityListViewItem(
                          city: viewModel.cities[index],
                          isSelected: viewModel.selectedCity == city,
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
                widget.onConfirm(viewModel.selectedCity);
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
