import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/tutorial/app/ui/helpers/tutorial_globalkey.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus tutorialRent({required VoidCallback onNext, required VoidCallback onSkip}) {
  return TargetFocus(
    identify: "tutorialRent",
    keyTarget: TutorialGlobalKey.tutorialRent,
    paddingFocus: 10,
    enableOverlayTab: true,
    borderSide: BorderSide(color: AppTheme.briteGold, width: 2.sp, style: BorderStyle.solid),
    contents: [
      TargetContent(
        align: ContentAlign.custom,
        customPosition: CustomTargetContentPosition(top: 32.h),
        builder: (context, controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onSkip,
                    child: SizedBox(
                      height: 50.h,
                      child: Text(
                        LocaleKeys.tutorial_skip_all.trans(),
                        style: AppTheme.white_16w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onNext,
                    child: SizedBox(
                      height: 50.h,
                      child: Text(
                        LocaleKeys.tutorial_next.trans(),
                        style: AppTheme.white_16w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 90.h,
              ),
              SizedBox(
                width: 247.w,
                child: Text(LocaleKeys.tutorial_tutorial_rent.trans(), style: AppTheme.radiantGlow_18w700),
              ),
              SizedBox(height: 17.h),
              Padding(
                padding: EdgeInsets.only(left: 75.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 88.h,
                      width: 103.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.icons.icTutorialArrowRent.path),
                          fit: BoxFit.contain,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}
