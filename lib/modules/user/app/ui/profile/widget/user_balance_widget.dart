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

class UserBalanceWidget extends StatelessWidget {
  final int coin;
  final int? freeUsage;
  final int cone;

  const UserBalanceWidget({
    Key? key,
    required this.coin,
    this.freeUsage,
    required this.cone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Assets.images.imgBalanceBackgroundV2.image(
          width: 345.w,
          height: 82.h,
          fit: BoxFit.fill,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys.user_your_wallet.trans(),
                          style: AppTheme.white_14w400,
                        ),
                        Visibility(
                          visible: (freeUsage ?? 0) > 0,
                          child: Expanded(
                            child: Text(
                              " (${LocaleKeys.user_free_usage_promo.trans()}: $freeUsage)",
                              style: AppTheme.white_14w400,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 55,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(4.w, 4.h, 8.w, 4.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme.masalaOrange,
                                      borderRadius: BorderRadius.circular(28.sp),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Assets.icons.icSantaCoin.image(width: 24.w, height: 24.w),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: constraints.maxWidth - 24.w - 14.w, minWidth: 20.w),
                                          child: Text(
                                            FormatHelper.formatCurrency(coin, unit: ''),
                                            style: AppTheme.white_14w400,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Expanded(
                          flex: 45,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(4.w, 4.h, 8.w, 4.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme.masalaOrange,
                                      borderRadius: BorderRadius.circular(28.sp),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Assets.icons.icConeV2.image(width: 24.w, height: 24.w),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: constraints.maxWidth - 24.w - 14.w, minWidth: 20.w),
                                          child: Text(
                                            FormatHelper.formatCurrency(cone, unit: ''),
                                            style: AppTheme.white_14w400,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => const PaymentPage());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 30.w,
                    ),
                    child: Column(
                      children: [
                        Assets.icons.icTopupWallet.image(
                          height: 30.h,
                          width: 30.w,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          LocaleKeys.user_top_up_xu.trans(),
                          style: AppTheme.white_14w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
