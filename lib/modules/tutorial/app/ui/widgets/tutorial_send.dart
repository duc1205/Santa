import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/tutorial/app/ui/helpers/tutorial_globalkey.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus tutorialSend({required VoidCallback onNext, required VoidCallback onSkip}) {
  return TargetFocus(
    identify: "tutorialSend",
    keyTarget: TutorialGlobalKey.tutorialSend,
    paddingFocus: 10,
    enableOverlayTab: true,
    borderSide: BorderSide(color: AppTheme.briteGold, width: 2.sp, style: BorderStyle.solid),
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
                height: 134.h,
              ),
              SizedBox(
                child: Text(LocaleKeys.tutorial_tutorial_send.trans(), style: AppTheme.radiantGlow_18w700),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Container(
                  height: 72.h,
                  width: 61.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.icons.icTutorialArrowSend.path),
                      fit: BoxFit.contain,
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}
