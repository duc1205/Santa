import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReopenPocketCompletePage extends StatelessWidget {
  const ReopenPocketCompletePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 62.w,
              ),
              child: Text(
                LocaleKeys.delivery_process_completed.trans(),
                style: AppTheme.green_20w600,
              ),
            ),
            const Spacer(),
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
    );
  }
}
