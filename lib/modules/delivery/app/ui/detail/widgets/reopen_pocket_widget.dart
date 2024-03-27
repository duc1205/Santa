import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReopenPocketWidget extends StatelessWidget {
  final Delivery? delivery;
  final VoidCallback callBack;

  const ReopenPocketWidget({Key? key, required this.delivery, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.h,
            ),
            SizedBox(width: double.infinity, child: Assets.images.imgReopenPocketBackground.image()),
            SizedBox(
              height: 26.h,
            ),
            Center(
              child: Text(
                LocaleKeys.delivery_open_pocket.trans(),
                style: AppTheme.blackDark_24W600,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppTheme.orange6,
                border: Border.all(
                  color: AppTheme.goldishOrange,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                delivery?.cabinet?.name ?? "",
                style: AppTheme.goldishOrange_14w400,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppTheme.winterMistGreen,
                border: Border.all(
                  color: AppTheme.algalGreen,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "${LocaleKeys.delivery_pocket.trans()} ${delivery?.pocket?.localId}",
                style: AppTheme.algalGreen_14w400,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              LocaleKeys.delivery_confirm_reopen_message.trans(),
              style: AppTheme.blackDark_14w400,
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.border,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.r),
                            ),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.delivery_cancel.trans(),
                          style: AppTheme.white_14w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          callBack();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.r),
                            ),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.delivery_scan_qr.trans(),
                          style: AppTheme.white_14w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
