import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class BalanceNotEnoughReceiveWidget extends StatelessWidget {
  final String? phoneHotLine;
  final String? zaloUri;

  const BalanceNotEnoughReceiveWidget({Key? key, required this.phoneHotLine, required this.zaloUri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(right: 18.w),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                color: AppTheme.grey,
                size: 20.sp,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Assets.images.imgBalanceNotEnough.image(
          width: 181.w,
          height: 78.h,
        ),
        SizedBox(
          height: 19.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: Text(
            LocaleKeys.delivery_notice_balance_v2.trans(),
            style: AppTheme.black_16,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => callHotLine(phoneHotLine),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.only(
                    top: 4.h,
                    bottom: 10.h,
                  ),
                  child: Column(
                    children: [
                      Assets.icons.icPhone.image(),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        LocaleKeys.delivery_call_hotline.trans(),
                        style: AppTheme.black_14w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            GestureDetector(
              onTap: () {
                launchUri("http://zalo.me/$zaloUri");
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.only(
                    top: 4.h,
                    bottom: 10.h,
                  ),
                  child: Column(
                    children: [
                      Assets.icons.icHomeZalo.image(),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        LocaleKeys.delivery_chat_zalo.trans(),
                        style: AppTheme.black_14w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 19.h,
        ),
        Container(
          height: 50.h,
          width: 300.w,
          margin: EdgeInsets.symmetric(horizontal: 37.5.w),
          child: ElevatedButton(
            onPressed: () => Get.to(() => const PaymentPage()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Center(
              child: Text(
                LocaleKeys.delivery_top_up_xu.trans(),
                style: AppTheme.white_16w600,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
