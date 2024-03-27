import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/widgets/no_result_found.dart';
import 'package:santapocket/modules/charity/app/ui/charity_phone_number_picker/volunteers/volunteers_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/charity_phone_number_picker/volunteers/widgets/volunteer_item.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({
    Key? key,
    required this.delivery,
    required this.onSelect,
  }) : super(key: key);

  final Delivery delivery;
  final Function(String, {String? name}) onSelect;

  @override
  State<VolunteersPage> createState() => _VolunteersPageState();
}

class _VolunteersPageState extends BaseViewState<VolunteersPage, VolunteersPageViewModel> {
  @override
  VolunteersPageViewModel createViewModel() => locator<VolunteersPageViewModel>();

  @override
  void loadArguments() {
    viewModel.delivery = widget.delivery;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => viewModel.refreshCharities(true),
      child: Obx(
        () => Column(children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: DebounceTextfield(
              action: viewModel.filterCabinets,
              controller: viewModel.controller,
              duration: const Duration(milliseconds: 300),
              onTextfieldEmpty: () => viewModel.refreshCharities(false),
              textFieldStyle: AppTheme.blackDark_14w400,
              inputDecoration: InputDecoration(
                hintText: LocaleKeys.charity_search.trans(),
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
                          await viewModel.refreshCharities(false);
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
          if (viewModel.listVolunteers.isEmpty)
            const NoResultFound()
          else
            Expanded(
              child: EasyListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                scrollbarEnable: false,
                itemCount: viewModel.listVolunteers.length,
                onLoadMore: () => viewModel.onLoadMore(),
                loadMore: viewModel.canLoadMore,
                itemBuilder: (context, index) {
                  return Column(children: [
                    VolunteerItem(
                      volunteer: viewModel.listVolunteers[index],
                      isSelected: viewModel.selectedIndex == index,
                      itemClick: () => viewModel.onItemClick(index),
                    ),
                  ]);
                },
                loadMoreItemBuilder: (context) {
                  return const LoadMoreView();
                },
                placeholderWidget: const NoResultFound(),
              ),
            ),
          Visibility(
            visible: viewModel.selectedIndex > -1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50.h,
                width: 300.w,
                margin: EdgeInsets.symmetric(horizontal: 37.5.w, vertical: 20.h),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                      final selected = viewModel.listVolunteers[viewModel.selectedIndex];
                      widget.onSelect(selected.phoneNumber, name: selected.name ?? selected.user.name ?? LocaleKeys.charity_unknown.trans());
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                    ),
                    child: Center(child: Text(LocaleKeys.charity_select.trans(), style: AppTheme.white_16w600)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
