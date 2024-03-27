import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class TopupInformationDialog extends StatelessWidget {
  final Function() onConfirm;
  final Function() onPressHere;
  const TopupInformationDialog({super.key, required this.onConfirm, required this.onPressHere});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          child: SizedBox(
            width: 320.w,
            height: 295.h,
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  LocaleKeys.payment_announcement.trans(),
                  style: AppTheme.yellow1_20w600,
                ),
                SizedBox(
                  height: 14.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Text(
                    LocaleKeys.payment_santa_coin_message.trans(),
                    style: AppTheme.blackDark_14w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                RichText(
                  text: TextSpan(
                    text: LocaleKeys.payment_refer.trans(),
                    style: AppTheme.blackDark_14w400,
                    children: [
                      TextSpan(
                        text: " ${LocaleKeys.payment_here.trans().toLowerCase()}.",
                        style: AppTheme.blueDark_14w400,
                        recognizer: TapGestureRecognizer()..onTap = onPressHere,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15.r)),
                              color: Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.payment_cancel.trans(),
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
                        child: GestureDetector(
                          onTap: onConfirm,
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15.r)),
                              color: Colors.amber,
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.payment_confirm.trans(),
                                style: AppTheme.white_14w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(top: 200.h, left: 117.w, right: 117.w, child: Assets.images.imgCoinTopup.image()),
      ],
    );
  }
}
