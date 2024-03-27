import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/tutorial/app/ui/helpers/tutorial_globalkey.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus tutorialFreeUsage({required VoidCallback onNext, required VoidCallback onSkip}) {
  return TargetFocus(
    identify: "tutorialFreeUsage",
    keyTarget: TutorialGlobalKey.tutorialFreeUsage,
    enableOverlayTab: true,
    paddingFocus: 10,
    borderSide: BorderSide(color: AppTheme.radiantGlow, width: 2.sp, style: BorderStyle.solid),
    contents: [
      TargetContent(
        align: ContentAlign.custom,
        customPosition: CustomTargetContentPosition(top: 32.h),
        builder: (context, controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
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
                height: 50.h,
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 125.w),
                    child: Row(
                      children: [
                        Container(
                          height: 90.h,
                          width: 210.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.icons.icTutorialConfetti.path),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.w, top: 10.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 241.w,
                          child: Text(LocaleKeys.tutorial_tutorial_free_usage.trans(), style: AppTheme.radiantGlow_18w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ],
  );
}
