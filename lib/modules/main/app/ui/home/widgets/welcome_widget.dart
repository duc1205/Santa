import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Assets.icons.icHomeWelcome.image(
            width: 188.w,
            height: 90.h,
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            LocaleKeys.main_let_start_using_cabinets.trans(),
            style: AppTheme.black_16,
          ),
        ],
      ),
    );
  }
}
