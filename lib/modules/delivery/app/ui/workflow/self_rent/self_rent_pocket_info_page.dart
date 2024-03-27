import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_info_page_viewmodel.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/package_category_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/pocket_sizes_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class SelfRentPocketInfoPage extends StatefulWidget {
  const SelfRentPocketInfoPage({
    Key? key,
    required this.cabinetInfo,
  }) : super(key: key);

  final CabinetInfo cabinetInfo;

  @override
  State<SelfRentPocketInfoPage> createState() => _SelfRentPocketInfoPageState();
}

class _SelfRentPocketInfoPageState extends BaseViewState<SelfRentPocketInfoPage, SelfRentPocketInfoPageViewModel> {
  @override
  SelfRentPocketInfoPageViewModel createViewModel() => locator<SelfRentPocketInfoPageViewModel>();

  @override
  void loadArguments() {
    viewModel.cabinetInfo = widget.cabinetInfo;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.cabinetInfo.name,
          style: AppTheme.black_16bold,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 13.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
                    decoration: BoxDecoration(
                      color: AppTheme.orangeLight,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                LocaleKeys.delivery_receiver_phone_number.trans(),
                                style: AppTheme.orange_14bold,
                              ),
                              Text(
                                "*",
                                style: AppTheme.red_20,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            viewModel.user?.phoneNumber ?? "",
                            style: AppTheme.grey_14w400Roboto,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Divider(
                            height: 1.h,
                            thickness: 1.w,
                            color: AppTheme.borderLight,
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            LocaleKeys.delivery_receiver_name.trans(),
                            style: AppTheme.orange_14bold,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            viewModel.user?.name ?? "",
                            style: AppTheme.grey_14w400Roboto,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Divider(
                            height: 1.h,
                            thickness: 1.w,
                            color: AppTheme.borderLight,
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            LocaleKeys.delivery_note.trans(),
                            style: AppTheme.orange_14bold,
                          ),
                          TextField(
                            onChanged: viewModel.setNotes,
                            style: AppTheme.blackDark_14,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.delivery_place_holder_note.trans(),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                              contentPadding: EdgeInsets.only(bottom: 5.h),
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppTheme.borderLight, width: 1.w),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppTheme.borderLight, width: 1.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: RichText(
                      text: TextSpan(
                        text: "*${LocaleKeys.delivery_attention.trans()}:",
                        style: AppTheme.red_14w700,
                        children: [
                          TextSpan(text: LocaleKeys.delivery_sender_policy_one.trans(), style: AppTheme.black_14w400),
                          TextSpan(text: LocaleKeys.delivery_less_than_2M_message.trans(), style: AppTheme.red_14w700),
                          TextSpan(text: LocaleKeys.delivery_sender_policy_two.trans(), style: AppTheme.black_14w400),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    color: AppTheme.grey.withOpacity(0.5),
                    height: 0.5.w,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.w),
                    child: Row(
                      children: [
                        Text(
                          LocaleKeys.delivery_select_package_category.trans(),
                          style: AppTheme.yellow_14w700,
                        ),
                        Text(
                          "*",
                          style: AppTheme.red_20,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => PackageCategoryWidget(
                      selectedCategory: viewModel.selectedCategory,
                      onSelectCategory: viewModel.onSelectCategory,
                    ),
                  ),
                  Divider(
                    color: AppTheme.grey.withOpacity(0.5),
                    height: 0.5.w,
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.w),
                    child: Row(
                      children: [
                        Text(
                          LocaleKeys.delivery_select_pocket_size.trans(),
                          style: AppTheme.yellow_14w700,
                        ),
                        Text(
                          "*",
                          style: AppTheme.red_20,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => PocketSizesWidget(
                      pocketSizes: viewModel.pocketSizes,
                      selectedPocketSizeIndex: viewModel.selectedIndex,
                      onSelectPocket: viewModel.setSelectedIndex,
                    ),
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  Container(
                    height: 50.h,
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SizedBox.expand(
                      child: TapDebouncer(
                        onTap: () async {
                          context.hideKeyboard();
                          await viewModel.handleSelfRent();
                        },
                        builder: (BuildContext context, Future<void> Function()? onTap) {
                          return Obx(
                            () => ElevatedButton(
                              onPressed: onTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: viewModel.isCouldSubmit ? AppTheme.orange : AppTheme.yellow4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.delivery_submit.trans(),
                                  style: AppTheme.white_16w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
