import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class AgreeToTermAndConditionDialog extends StatefulWidget {
  final Future<Unit> Function() onAccept;
  final VoidCallback onTermAndConditionTap;
  final VoidCallback onPrivacyPolicyTap;

  const AgreeToTermAndConditionDialog({
    required this.onAccept,
    required this.onTermAndConditionTap,
    required this.onPrivacyPolicyTap,
    Key? key,
  }) : super(key: key);

  @override
  State<AgreeToTermAndConditionDialog> createState() => _AgreeToTermAndConditionDialogState();
}

class _AgreeToTermAndConditionDialogState extends State<AgreeToTermAndConditionDialog> {
  bool isAccept = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.imgNoticeTermAndCondition.image(
              width: 33.w,
              height: 35.h,
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              LocaleKeys.delivery_notice.trans(),
              style: AppTheme.blackDark_24W600,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w, top: 2.h),
                  width: 14.w,
                  height: 14.w,
                  child: Checkbox(
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (!states.contains(MaterialState.selected)) {
                        return AppTheme.radioBorder;
                      }
                      return AppTheme.yellow1;
                    }),
                    value: isAccept,
                    onChanged: (value) {
                      setState(() {
                        isAccept = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: EasyRichText(
                    LocaleKeys.delivery_term_and_condition_description.trans(),
                    defaultStyle: AppTheme.blackDark_14.copyWith(height: 1.25.h),
                    patternList: [
                      EasyRichTextPattern(
                        targetString: LocaleKeys.delivery_terms_conditions_agreement.trans(),
                        style: AppTheme.gluttonyOrange_14,
                        recognizer: TapGestureRecognizer()..onTap = widget.onTermAndConditionTap,
                      ),
                      EasyRichTextPattern(
                        targetString: LocaleKeys.delivery_privacy_policy.trans(),
                        style: AppTheme.gluttonyOrange_14,
                        recognizer: TapGestureRecognizer()..onTap = widget.onPrivacyPolicyTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 31.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.sp),
                        color: AppTheme.border,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            LocaleKeys.delivery_later.trans(),
                            style: AppTheme.white_14w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.sp),
                      color: isAccept ? AppTheme.gluttonyOrange : AppTheme.yellow4,
                    ),
                    child: InkWell(
                      onTap: isAccept
                          ? () async {
                              await widget.onAccept();
                              Get.back();
                            }
                          : null,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            LocaleKeys.delivery_accept.trans(),
                            style: AppTheme.white_14w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
