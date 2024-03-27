import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/app/ui/cancel/cancel_delivery_state_page_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/guide_step_package_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/pocket_info_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CancelDeliveryStatePageView extends StatelessWidget {
  final CancelDeliveryStatePageViewModel viewModel;

  const CancelDeliveryStatePageView({Key? key, required this.viewModel}) : super(key: key);

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
                cabinetInfo: viewModel.cabinetInfo,
              ),
            ),
            const GuideStepPackageWidget(),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: TapDebouncer(
                onTap: () async {
                  await viewModel.onClickEndProcess();
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
          ],
        ),
      ),
    );
  }
}
