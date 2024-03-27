import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class NoticeUserNotEnoughBalanceToReceiveWidget extends StatelessWidget {
  final Function() notifyUser;

  const NoticeUserNotEnoughBalanceToReceiveWidget({Key? key, required this.notifyUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 17.h,
        ),
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
          height: 17.h,
        ),
        Assets.images.imgNotifyBalanceBackground.image(
          width: 181.w,
          height: 78.h,
        ),
        SizedBox(
          height: 19.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 63.w),
          child: Text(
            LocaleKeys.delivery_authorization_package_owner_balance_is_not_enough_to_receive.trans(),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 31.h,
        ),
        TextButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.5.h),
            backgroundColor: AppTheme.cyan,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            minimumSize: Size(300.w, 50.h),
          ),
          onPressed: notifyUser,
          child: Text(
            LocaleKeys.delivery_authorization_notify_owner.trans(),
            style: AppTheme.blackDark_16w600,
          ),
        ),
        SizedBox(
          height: 19.h,
        ),
      ],
    );
  }
}
