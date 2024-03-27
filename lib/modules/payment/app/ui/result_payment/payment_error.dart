import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart' as utils;
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PaymentError extends StatelessWidget {
  const PaymentError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 180.h,
            ),
            Assets.images.imgPaymentError.image(
              width: 233.w,
              height: 158.h,
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              LocaleKeys.payment_error.trans(),
              style: AppTheme.blackDark_20w600,
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              LocaleKeys.payment_payment_error.trans(),
              style: AppTheme.black_14,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                left: 32.w,
                right: 32.w,
                bottom: 12.h,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.off(() => const PaymentPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppTheme.orangeA43, width: 1.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Text(
                      LocaleKeys.payment_try_again.trans(),
                      style: AppTheme.orange_16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 32.w,
                right: 32.w,
                bottom: 30.h,
              ),
              child: ElevatedButton(
                onPressed: () => utils.backPageOrHome(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Text(
                      LocaleKeys.payment_back_home.trans(),
                      style: AppTheme.white_16w600,
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
