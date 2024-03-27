import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class NotifyUpdateView extends StatelessWidget {
  final ImageProvider image;
  final String text;
  final Color color;

  static const String _iosAppId = "1507758260";

  const NotifyUpdateView({
    Key? key,
    required this.image,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: AppTheme.black.withOpacity(0.1),
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image(
                image: image,
                width: 19.25.w,
                height: 19.25.h,
              ),
              SizedBox(
                width: 13.w,
              ),
              Expanded(
                child: Text(
                  text,
                  style: AppTheme.black_14,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          SizedBox(
            width: 97.w,
            height: 31.h,
            child: TextButton(
              onPressed: redirectUpdate,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              child: FittedBox(
                child: Text(
                  LocaleKeys.version_update.trans().toUpperCase(),
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future redirectUpdate() async {
    final info = await PackageInfo.fromPlatform();
    await LaunchReview.launch(
      androidAppId: info.packageName,
      writeReview: false,
      iOSAppId: _iosAppId,
    );
  }
}
