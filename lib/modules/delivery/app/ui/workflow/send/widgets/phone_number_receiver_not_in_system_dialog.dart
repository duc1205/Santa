import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PhoneNumberReceiverNotInSystemDialog extends StatelessWidget {
  final String phoneNumber;
  final CabinetInfo cabinetInfo;
  final Function() onConfirm;

  const PhoneNumberReceiverNotInSystemDialog({
    required this.phoneNumber,
    required this.cabinetInfo,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 41.h,
          ),
          Assets.images.imgPhoneNumberNotFoundBackground.image(
            width: 164.w,
            height: 70.h,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 26.h,
          ),
          Text(
            phoneNumber,
            style: AppTheme.blackDark_24W600,
          ),
          SizedBox(
            height: 13.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              LocaleKeys.delivery_phone_number_not_in_system.trans(),
              style: AppTheme.black_16w600,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: SizedBox(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.sp),
                        color: AppTheme.border,
                      ),
                      child: InkWell(
                        onTap: () => Get.back(),
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
                        color: AppTheme.orange,
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          onConfirm();
                        },
                        child: Center(
                          child: Text(
                            LocaleKeys.delivery_confirm.trans(),
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
