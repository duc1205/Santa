import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CoinBalanceWidget extends StatelessWidget {
  final int balance;

  const CoinBalanceWidget({
    Key? key,
    required this.balance,
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
                  LocaleKeys.user_total_santa_xu.trans(),
                  style: AppTheme.blackDark_14,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Assets.icons.icSantaCoin.image(width: 24.w),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      FormatHelper.formatCurrency(balance, unit: ""),
                      style: AppTheme.yellow1_25w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const PaymentPage());
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 18.w),
              decoration: BoxDecoration(
                color: AppTheme.red,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                LocaleKeys.user_top_up_xu.trans(),
                style: AppTheme.white_14w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
