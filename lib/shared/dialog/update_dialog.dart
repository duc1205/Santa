import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class UpdateDialog extends StatelessWidget {
  static const _iosAppId = "1507758260";

  const UpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.r,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            8.r,
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  LocaleKeys.shared_update_app.trans(),
                  style: AppTheme.black_18,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 32.h,
                ),
                Container(
                  width: double.infinity,
                  color: AppTheme.orange,
                  child: TextButton(
                    onPressed: () async {
                      final info = await PackageInfo.fromPlatform();
                      await LaunchReview.launch(
                        androidAppId: info.packageName,
                        writeReview: false,
                        iOSAppId: _iosAppId,
                      );
                    },
                    child: Text(
                      LocaleKeys.shared_update.trans(),
                      style: AppTheme.white_16w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
