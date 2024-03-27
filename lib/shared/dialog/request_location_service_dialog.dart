import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class RequestLocationServiceDialog extends StatelessWidget {
  const RequestLocationServiceDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 0.0,
      backgroundColor: AppTheme.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 34.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 22.h,
            ),
            Assets.images.imgLocationPermissionBackground.image(width: 191.w),
            SizedBox(
              height: 15.h,
            ),
            Text(
              LocaleKeys.shared_location.trans(),
              style: AppTheme.blackDark_16bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              LocaleKeys.shared_location_permission_body.trans(),
              style: AppTheme.grey1_14w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 65.h,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.gluttonyOrange,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  Get.back();
                },
                child: Text(
                  LocaleKeys.shared_allow_permission.trans(),
                  style: AppTheme.white_14,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                onPressed: () async {
                  Get.back();
                },
                child: Text(
                  LocaleKeys.shared_later.trans(),
                  style: AppTheme.grey_14w400,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
