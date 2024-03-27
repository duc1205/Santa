import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CancelPackageCompletePage extends StatelessWidget {
  const CancelPackageCompletePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 198.h,
            ),
            Assets.images.imgDeliverySuccess.image(
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
              height: 9.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: Text(
                LocaleKeys.delivery_canceling_pocket_completed.trans(),
                style: AppTheme.blackDark_14w400,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 9.h,
            ),
            const Spacer(),
            SizedBox(
              height: 12.h,
            ),
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
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
