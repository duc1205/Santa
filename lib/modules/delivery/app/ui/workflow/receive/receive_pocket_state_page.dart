import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/charity/app/ui/workflow/send/widgets/charity_pocket_info_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_pocket_state_page_viewmodel.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/guide_step_package_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ReceivePocketStatePage extends StatefulWidget {
  const ReceivePocketStatePage({
    Key? key,
    required this.deliveryId,
    required this.cabinetInfo,
    this.isCharity = false,
  }) : super(key: key);

  final int deliveryId;
  final CabinetInfo cabinetInfo;
  final bool isCharity;

  @override
  State<ReceivePocketStatePage> createState() => _ReceivePocketStatePageState();
}

class _ReceivePocketStatePageState extends BaseViewState<ReceivePocketStatePage, ReceivePocketStatePageViewModel> {
  @override
  void loadArguments() {
    viewModel.cabinetInfo = widget.cabinetInfo;
    viewModel.deliveryId = widget.deliveryId;
    super.loadArguments();
  }

  @override
  ReceivePocketStatePageViewModel createViewModel() => locator<ReceivePocketStatePageViewModel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          backgroundColor: widget.isCharity ? AppTheme.danger2 : Colors.white,
          title: Text(
            "${LocaleKeys.delivery_delivery_id.trans().toUpperCase()} ${FormatHelper.formatId(viewModel.deliveryId)}",
            style: AppTheme.black_18w600,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: widget.isCharity
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [AppTheme.carnationBloom.withOpacity(0.3), AppTheme.white],
                    stops: const [
                      0.01,
                      0.6,
                    ],
                  ),
                )
              : null,
          child: Column(
            children: [
              const DeliveryStepsWidget(
                step: 2,
                isReceiving: true,
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
                () => CharityPocketInfoWidget(
                  delivery: viewModel.delivery,
                  pocketIsOpen: viewModel.isOpened,
                  cabinetInfo: widget.cabinetInfo,
                  receivePrice: viewModel.getReceivePrice,
                  receiveCoin: viewModel.getCoinAmount,
                ),
              ),
              const GuideStepPackageWidget(),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: TapDebouncer(
                  onTap: () async => viewModel.onClickEndProcess(),
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
