import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class NotificationEmptyView extends StatelessWidget {
  const NotificationEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.14.sh,
        ),
        Assets.images.imgNotificationEmpty.image(),
        SizedBox(
          height: 32.h,
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            LocaleKeys.notification_empty_description.trans(),
            style: AppTheme.black_16w600,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
