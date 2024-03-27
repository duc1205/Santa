import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PayrollCancelDialog extends StatelessWidget {
  final Function() onConfirm;
  const PayrollCancelDialog({Key? key, required this.onConfirm}) : super(key: key);

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
            height: 28.h,
          ),
          Assets.icons.icHrmUnregister.image(),
          SizedBox(
            height: 20.h,
          ),
          Text(
            LocaleKeys.hrm_payroll_cancel_message.trans(),
            style: AppTheme.black_14w400,
          ),
          SizedBox(
            height: 25.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      backgroundColor: AppTheme.red1,
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      LocaleKeys.hrm_payroll_no.trans(),
                      style: AppTheme.white_14w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      backgroundColor: AppTheme.border,
                    ),
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Text(
                      LocaleKeys.hrm_payroll_yes_im_sure.trans(),
                      style: AppTheme.white_14w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
