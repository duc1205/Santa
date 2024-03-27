import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/reopen_pocket/reopen_pocket_state_page_viewmodel.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/guide_step_package_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/pocket_info_widget.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ReopenPocketStatePage extends StatefulWidget {
  const ReopenPocketStatePage({
    required this.delivery,
    required this.cabinetInfo,
    required this.reopenRequestId,
    this.isCharity = false,
    Key? key,
  }) : super(key: key);

  final Delivery delivery;
  final CabinetInfo cabinetInfo;
  final int reopenRequestId;
  final bool isCharity;

  @override
  State<ReopenPocketStatePage> createState() => _ReopenPocketStatePageState();
}

class _ReopenPocketStatePageState extends BaseViewState<ReopenPocketStatePage, ReopenPocketStatePageViewModel> with WidgetsBindingObserver {
  @override
  ReopenPocketStatePageViewModel createViewModel() => locator<ReopenPocketStatePageViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void loadArguments() {
    viewModel.delivery = widget.delivery;
    viewModel.cabinetInfo = widget.cabinetInfo;
    viewModel.reopenRequestId = widget.reopenRequestId;
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
          backgroundColor: widget.isCharity ? AppTheme.danger2 : Colors.white,
          title: Text(
            "${LocaleKeys.delivery_delivery_id.trans().toUpperCase()} ${FormatHelper.formatId(viewModel.delivery.id)}",
            style: AppTheme.black_18w600,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [AppTheme.carnationBloom.withOpacity(0.3), AppTheme.white],
              stops: const [
                0.01,
                0.6,
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
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
                                viewModel.delivery.cabinet?.location?.address ?? "",
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
              Obx(
                () => PocketInfoWidget(
                  delivery: viewModel.delivery,
                  pocketIsOpen: viewModel.isOpened,
                  cabinetInfo: widget.cabinetInfo,
                ),
              ),
              const GuideStepPackageWidget(),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: TapDebouncer(
                  onTap: () async => viewModel.endProcess(),
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
            ],
          ),
        ),
      ),
    );
  }
}
