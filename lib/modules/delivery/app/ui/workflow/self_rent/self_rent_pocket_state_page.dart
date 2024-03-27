import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_state_page_viewmodel.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/guide_step_package_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/pocket_info_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class SelfRentPocketStatePage extends StatefulWidget {
  const SelfRentPocketStatePage({
    required this.deliveryId,
    required this.cabinetInfo,
    Key? key,
  }) : super(key: key);

  final int deliveryId;
  final CabinetInfo cabinetInfo;

  @override
  State<SelfRentPocketStatePage> createState() => _SelfRentPocketStatePageState();
}

class _SelfRentPocketStatePageState extends BaseViewState<SelfRentPocketStatePage, SelfRentPocketStatePageViewModel> with WidgetsBindingObserver {
  @override
  SelfRentPocketStatePageViewModel createViewModel() => locator<SelfRentPocketStatePageViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void loadArguments() {
    viewModel.deliveryId = widget.deliveryId;
    viewModel.cabinetInfo = widget.cabinetInfo;
    super.loadArguments();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      viewModel.handleWhenAppPaused();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          backgroundColor: Colors.white,
          title: Text(
            "${LocaleKeys.delivery_delivery_id.trans().toUpperCase()} ${FormatHelper.formatId(viewModel.deliveryId)}",
            style: AppTheme.black_18w600,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            const DeliveryStepsWidget(
              step: 2,
              isReceiving: false,
            ),
            Obx(
              () => Container(
                color: AppTheme.radiantGlow,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Assets.icons.icDeliveryPinPoint.image(),
                      SizedBox(
                        width: 14.w,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.cabinetInfo.name,
                                style: AppTheme.blackDark_16w600,
                              ),
                              Text(
                                viewModel.delivery?.cabinet?.location?.address ?? "",
                                style: AppTheme.black_14w400,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => PocketInfoWidget(
                delivery: viewModel.delivery,
                pocketIsOpen: viewModel.isOpened,
                cabinetInfo: widget.cabinetInfo,
              ),
            ),
            const GuideStepPackageWidget(),
            const Spacer(),
            Obx(
              () => Visibility(
                visible: viewModel.cancelable,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: TapDebouncer(
                          onTap: () async {
                            viewModel.showCancelSendingDialog();
                          },
                          builder: (BuildContext context, TapDebouncerFunc? onTap) => TextButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              backgroundColor: AppTheme.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                side: const BorderSide(color: AppTheme.orange),
                              ),
                              minimumSize: Size(167.w, 50.h),
                            ),
                            onPressed: onTap,
                            child: Center(
                              child: Text(
                                LocaleKeys.delivery_cancel_process.trans(),
                                style: AppTheme.yellow1_14w600,
                                textAlign: TextAlign.center,
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
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => Visibility(
                visible: viewModel.cancelable,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: TapDebouncer(
                    onTap: () async {
                      viewModel.showChangePocketSize();
                    },
                    builder: (BuildContext context, TapDebouncerFunc? onTap) => TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                        backgroundColor: AppTheme.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          side: const BorderSide(color: AppTheme.orange),
                        ),
                      ),
                      onPressed: onTap,
                      child: Center(
                        child: Text(
                          LocaleKeys.delivery_select_size_again.trans(),
                          style: AppTheme.yellow1_14w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TapDebouncer(
                onTap: () async {
                  await viewModel.endProcess();
                },
                builder: (BuildContext context, TapDebouncerFunc? onTap) => TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    backgroundColor: AppTheme.yellow1,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      side: const BorderSide(color: AppTheme.orange),
                    ),
                  ),
                  onPressed: onTap,
                  child: Center(
                    child: Text(
                      LocaleKeys.delivery_finish_process.trans(),
                      style: AppTheme.white_14w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
