import 'package:dotted_line/dotted_line.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class GuideStepPackageWidget extends StatelessWidget {
  const GuideStepPackageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppTheme.sweetFrostingOrange,
      ),
      child: Column(
        children: [
          Text(
            LocaleKeys.delivery_guide_step_receive.trans(),
            style: AppTheme.blackDark_18w600,
          ),
          SizedBox(
            height: 18.h,
          ),
          SizedBox(
            height: 142.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: const BoxDecoration(
                        color: AppTheme.orangeDark2,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.circle,
                        color: AppTheme.coffeeOrange,
                        size: 6.sp,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        child: VerticalDivider(
                          color: AppTheme.orangeDark2,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: const BoxDecoration(
                        color: AppTheme.orangeDark2,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.circle,
                        color: AppTheme.coffeeOrange,
                        size: 6.sp,
                      ),
                    ),
                    SizedBox(
                      height: 42.h,
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.delivery_step_one.trans(),
                          style: AppTheme.windsorGrey_12w400,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          LocaleKeys.delivery_guide_step_one_description.trans(),
                          style: AppTheme.black_14w400,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        const DottedLine(dashColor: AppTheme.borderLight, lineThickness: 1),
                        const Spacer(),
                        Text(
                          LocaleKeys.delivery_step_two.trans(),
                          style: AppTheme.windsorGrey_12w400,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        EasyRichText(
                          LocaleKeys.delivery_guide_step_two_description.trans(),
                          defaultStyle: AppTheme.black_14w400,
                          patternList: [
                            EasyRichTextPattern(
                              targetString: LocaleKeys.delivery_close.trans(),
                              style: AppTheme.black_14w600,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        const DottedLine(dashColor: AppTheme.borderLight, lineThickness: 1),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
