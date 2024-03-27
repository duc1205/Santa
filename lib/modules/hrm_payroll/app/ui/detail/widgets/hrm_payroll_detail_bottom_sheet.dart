import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class HrmPayrollDetailBottomSheet extends StatelessWidget {
  final VoidCallback onPolicyClicked;
  final VoidCallback onUnregisterClick;
  const HrmPayrollDetailBottomSheet({
    Key? key,
    required this.onPolicyClicked,
    required this.onUnregisterClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 25.w, top: 17.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.hrm_payroll_santa_payroll.trans().toUpperCase(),
                style: AppTheme.yellow1_14w700,
              ),
              const Icon(Icons.close, color: AppTheme.greyIcon),
            ],
          ),
        ),
        Divider(thickness: 1.sp),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 15.w),
          child: GestureDetector(
            onTap: onPolicyClicked,
            child: Row(
              children: [
                Assets.icons.icHrmPolicy.image(),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(child: Text(LocaleKeys.hrm_payroll_policies.trans(), style: AppTheme.black_14w400)),
                Assets.icons.icHelpCenterArrowForward.image(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 15.w),
          child: GestureDetector(
            onTap: onUnregisterClick,
            child: Row(
              children: [
                Assets.icons.icHrmCancel.image(),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Text(
                    LocaleKeys.hrm_payroll_unregister.trans(),
                    style: AppTheme.red1_14w400,
                  ),
                ),
                Assets.icons.icHelpCenterArrowForward.image(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
      ],
    );
  }
}
