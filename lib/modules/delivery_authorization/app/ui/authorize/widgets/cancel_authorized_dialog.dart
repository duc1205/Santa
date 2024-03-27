import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CancelAuthorizedDialog extends StatelessWidget {
  final Future<Unit> Function() onConfirmCancel;

  const CancelAuthorizedDialog({
    required this.onConfirmCancel,
    Key? key,
  }) : super(key: key);

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
          Assets.images.imgCancelAuthorized.image(
            width: 185.w,
            height: 102.h,
          ),
          SizedBox(
            height: 25.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w).copyWith(bottom: 5.h),
            child: Text(
              LocaleKeys.delivery_authorization_cancel_authorization.trans(),
              style: AppTheme.blackDark_24W600,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              LocaleKeys.delivery_authorization_cancel_authorization_verify.trans(),
              style: AppTheme.blackDark_14,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20.h,
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
                            LocaleKeys.delivery_authorization_cancel.trans(),
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
                        color: AppTheme.red,
                      ),
                      child: InkWell(
                        onTap: () => onConfirmCancel(),
                        child: Center(
                          child: Text(
                            LocaleKeys.delivery_authorization_yes_im_sure.trans(),
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
