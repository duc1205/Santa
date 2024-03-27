import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class DeliveryStepsWidget extends StatelessWidget {
  final int step;
  final bool isLastStepFailed;
  final bool isReceiving;
  const DeliveryStepsWidget({super.key, required this.step, this.isLastStepFailed = false, required this.isReceiving});

  Widget guideStepPackageWidget() {
    switch (step) {
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.yellow1,
                  ),
                  child: Center(child: Text("1", style: AppTheme.blackDark_12w400)),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  isReceiving ? LocaleKeys.delivery_select_package.trans() : LocaleKeys.delivery_fill_info.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightBorder,
                  ),
                  child: Center(child: Text("2", style: AppTheme.goldishOrange_12w400)),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  LocaleKeys.delivery_step_process.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightBorder,
                  ),
                  child: Center(child: Text("3", style: AppTheme.goldishOrange_12w400)),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  LocaleKeys.delivery_result.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.green,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.sp,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  isReceiving ? LocaleKeys.delivery_select_package.trans() : LocaleKeys.delivery_fill_info.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.yellow1,
                  ),
                  child: Center(child: Text("2", style: AppTheme.blackDark_12w400)),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  LocaleKeys.delivery_step_process.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightBorder,
                  ),
                  child: Center(child: Text("3", style: AppTheme.goldishOrange_12w400)),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  LocaleKeys.delivery_result.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.green,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.sp,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  isReceiving ? LocaleKeys.delivery_select_package.trans() : LocaleKeys.delivery_fill_info.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.green,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.sp,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  LocaleKeys.delivery_step_process.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLastStepFailed ? AppTheme.yellow1 : AppTheme.green,
                  ),
                  child: isLastStepFailed
                      ? Center(child: Text("3", style: AppTheme.blackDark_12w400))
                      : Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10.sp,
                        ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  LocaleKeys.delivery_result.trans(),
                  style: AppTheme.blackDark_12w400,
                ),
              ],
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: double.infinity,
      color: AppTheme.commercialWhite,
      child: guideStepPackageWidget(),
    );
  }
}
