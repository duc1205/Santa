import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CancelSendingDeliveryDialog extends StatelessWidget {
  final Function() onConfirmButtonClicked;

  const CancelSendingDeliveryDialog({Key? key, required this.onConfirmButtonClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 46.h,
          ),
          Assets.images.imgCancelDelivery.image(
            width: 181.w,
            height: 78.h,
          ),
          SizedBox(
            height: 25.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              LocaleKeys.delivery_confirm_cancel_description.trans(),
              style: AppTheme.blackDark_14,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            height: 1.h,
            color: const Color(0xFFE3EBF6),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: SizedBox(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.sp),
                          color: AppTheme.border,
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.delivery_cancel.trans(),
                            style: AppTheme.white_14w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.sp),
                        color: AppTheme.goldishOrange,
                      ),
                      child: InkWell(
                        onTap: onConfirmButtonClicked,
                        child: Center(
                          child: Text(
                            LocaleKeys.delivery_yes_im_sure.trans(),
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
        ],
      ),
    );
  }
}
