import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class RemoteRentPocketCompletePage extends StatelessWidget {
  final int deliveryId;
  final bool isCharity;

  const RemoteRentPocketCompletePage({
    Key? key,
    required this.deliveryId,
    required this.isCharity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 198.h,
            ),
            Assets.images.imgSuccessBackground.image(
              width: 294.w,
              height: 172.h,
            ),
            SizedBox(
              height: 23.h,
            ),
            Text(
              LocaleKeys.delivery_process_completed.trans(),
              style: AppTheme.green_20w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12.h,
            ),
            GestureDetector(
              onTap: () => Get.to(() => DeliveryDetailPage(
                    deliveryId: deliveryId,
                    isCharity: isCharity,
                  )),
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
            const Spacer(),
            SizedBox(
              width: 300.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => backPageOrHome(pageName: CharityPage.routeName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
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
            SizedBox(
              height: 19.h,
            ),
          ],
        ),
      ),
    );
  }
}
