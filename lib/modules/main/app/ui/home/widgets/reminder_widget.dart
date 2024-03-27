import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReminderWidget extends StatelessWidget {
  const ReminderWidget({required this.delivery, Key? key}) : super(key: key);
  final Delivery delivery;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => DeliveryDetailPage(
            deliveryId: delivery.id,
            isCharity: delivery.type == DeliveryType.charity,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16.r,
          ),
          color: AppTheme.orangeLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (delivery.authorization == null)
              Container(
                width: 50.w,
                height: 50.h,
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.r,
                  ),
                  color: AppTheme.orange,
                ),
                child: Assets.icons.icReminderNotification.image(
                  width: 24.w,
                  height: 24.h,
                ),
              )
            else
              Assets.icons.icReminderAuthorization.image(
                width: 55.w,
                height: 56.h,
              ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${LocaleKeys.main_reminder.trans()}:",
                    style: AppTheme.black_16bold,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  EasyRichText(
                    LocaleKeys.main_reminder_package.trans(
                      namedArgs: {
                        "cabinetName": delivery.cabinet?.name ?? "",
                        "pocket": "${LocaleKeys.main_pocket.trans()} ${delivery.extra?.pocketExtra?.localId ?? ""}",
                        "estimatedFee": FormatHelper.formatCurrencyV2(FormatHelper.roundSantaXu(delivery.estimatedReceivingPrice ?? 0)),
                      },
                    ),
                    defaultStyle: AppTheme.blackDark_14w400,
                    patternList: [
                      EasyRichTextPattern(
                        targetString:
                            "${delivery.cabinet?.name ?? ""} - ${LocaleKeys.main_pocket.trans()} ${delivery.extra?.pocketExtra?.localId ?? ""}",
                        style: AppTheme.orange_14w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
