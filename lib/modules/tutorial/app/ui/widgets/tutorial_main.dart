import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus tutorialMain({required VoidCallback onNext, required VoidCallback onSkip}) {
  return TargetFocus(
    identify: "main_tutorial",
    targetPosition: TargetPosition(Size.zero, const Offset(1, 1)),
    enableOverlayTab: true,
    // paddingFocus: 10,
    focusAnimationDuration: Duration.zero,
    color: Colors.black,
    pulseVariation: Tween(begin: 1, end: 1),
    contents: [
      TargetContent(
        align: ContentAlign.custom,
        customPosition: CustomTargetContentPosition(top: 32.h),
        builder: (context, controller) {
          return Column(
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
                height: 170.h,
              ),
              Container(
                height: 200.h,
                width: 200.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.icons.icTutorialBoxOpen.path),
                    fit: BoxFit.contain,
                  ),
                  color: Colors.transparent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h, left: 31.w, right: 31.w),
                child: Text(
                  LocaleKeys.tutorial_tutorial_main.trans(),
                  style: AppTheme.radiantGlow_18w700,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}
