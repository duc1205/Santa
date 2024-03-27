import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send/send_package_info_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/delivery_steps_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PocketSendCompletePage extends StatelessWidget {
  final CabinetInfo cabinetInfo;
  final int deliveryId;
  final bool isCharity;

  const PocketSendCompletePage({
    required this.cabinetInfo,
    required this.deliveryId,
    required this.isCharity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "${LocaleKeys.delivery_delivery_id.trans().toUpperCase()} #$deliveryId",
            style: AppTheme.black_16w600,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const DeliveryStepsWidget(
                step: 3,
                isLastStepFailed: false,
                isReceiving: false,
              ),
              SizedBox(
                height: 87.h,
              ),
              Assets.images.imgDeliverySuccess.image(
                width: 294.w,
                height: 172.h,
              ),
              SizedBox(
                height: 23.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 62.w,
                ),
                child: Text(
                  LocaleKeys.delivery_process_completed.trans(),
                  style: AppTheme.green_20w600,
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.w),
                child: Text(
                  LocaleKeys.delivery_sending_success.trans(),
                  style: AppTheme.blackDark_14w400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              InkWell(
                onTap: () => Get.to(
                  () => DeliveryDetailPage(
                    deliveryId: deliveryId,
                    isCharity: isCharity,
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 20.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.delivery_view_delivery_detail.trans(),
                          style: AppTheme.yellow_14w400,
                        ),
                        SizedBox(width: 5.w),
                        SizedBox(
                          width: 10.w,
                          height: 10.h,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Assets.icons.icDoubleArrow.image(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => Get.to(
                      () => SendPackageInfoPage(
                        cabinetInfo: cabinetInfo,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 1.5.w, color: AppTheme.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        LocaleKeys.delivery_send_another.trans(),
                        style: AppTheme.orange_16w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => backPageOrHome(pageName: CharityPage.routeName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        LocaleKeys.delivery_back_home.trans(),
                        style: AppTheme.white_16w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
