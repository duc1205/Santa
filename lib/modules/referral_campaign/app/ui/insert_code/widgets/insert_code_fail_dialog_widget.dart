import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class InsertCodeFailDialogWidget extends StatelessWidget {
  final String? failMessage;
  const InsertCodeFailDialogWidget({super.key, required this.failMessage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 12.h,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: const Icon(Icons.close),
              ),
            ),
          ),
          Assets.icons.icReferralAnnouncement.image(),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w).copyWith(bottom: 5.h),
            child: Text(
              LocaleKeys.referral_campaign_announcement.trans(),
              style: AppTheme.blackDark_24W600,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              (failMessage?.isNotEmpty ?? false) ? failMessage! : LocaleKeys.referral_campaign_announcement_hint.trans(),
              style: AppTheme.blackDark_14,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20.h,
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
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.referral_campaign_confirm.trans(),
                            style: AppTheme.red_14w600,
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
