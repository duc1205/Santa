import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ConeBalanceWidget extends StatelessWidget {
  final int coin;

  const ConeBalanceWidget({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      color: AppTheme.radiantGlow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.user_total_cone.trans(),
                  style: AppTheme.blackDark_14,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Assets.icons.icSantaCone.image(width: 24.w),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      FormatHelper.formatCurrency(coin, unit: ""),
                      style: AppTheme.yellow1_25w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
