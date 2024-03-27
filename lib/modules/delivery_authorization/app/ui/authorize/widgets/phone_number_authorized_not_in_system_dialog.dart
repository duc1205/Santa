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
import 'package:url_launcher/url_launcher.dart';

class PhoneNumberAuthorizedNotInSystemDialog extends StatelessWidget {
  final String phoneNumber;
  final String? phoneHotline;

  const PhoneNumberAuthorizedNotInSystemDialog({
    required this.phoneNumber,
    required this.phoneHotline,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 17.h,
          ),
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () => Get.back(),
                child: SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: Icon(
                    Icons.close,
                    size: 22.sp,
                    color: AppTheme.grey.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
            ],
          ),
          SizedBox(
            height: 26.h,
          ),
          Assets.images.imgPhoneNumberNotFoundBackground.image(
            width: 164.w,
            height: 70.h,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 26.h,
          ),
          Text(
            phoneNumber,
            style: AppTheme.blackDark_24W600,
          ),
          SizedBox(
            height: 13.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: EasyRichText(
              LocaleKeys.delivery_authorization_phone_number_authorized_not_in_system.trans(
                namedArgs: {
                  "hotline": "Hotline ${phoneHotline ?? ""}",
                },
              ),
              textAlign: TextAlign.center,
              defaultStyle: AppTheme.blackDark_16w400,
              patternList: [
                EasyRichTextPattern(
                  targetString: "Hotline ${phoneHotline ?? ""}",
                  style: AppTheme.orange_16w600,
                  recognizer: TapGestureRecognizer()..onTap = () => callPhoneHotLine(phoneHotline),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 37.h,
          ),
        ],
      ),
    );
  }
}

Future<Unit> callPhoneHotLine(String? phoneHotline) async {
  final Uri urlCall = Uri(
    scheme: 'tel',
    path: phoneHotline ?? '',
  );
  await launchUrl(urlCall);
  return unit;
}
