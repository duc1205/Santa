import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class AuthorizeReceiverPackageSuccessDialog extends StatelessWidget {
  const AuthorizeReceiverPackageSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 17.h,
          ),
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () => Get.back(),
                child: SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: Icon(
                    Icons.close,
                    size: 22.sp,
                    color: AppTheme.grey.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
            ],
          ),
          SizedBox(
            height: 74.h,
          ),
          Assets.images.imgSuccessBackground.image(
            width: 158.w,
            height: 82.h,
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            LocaleKeys.delivery_authorization_successful_authorization.trans(),
            style: AppTheme.green_16W600,
          ),
          SizedBox(
            height: 98.h,
          ),
        ],
      ),
    );
  }
}
