import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReminderDeliveryAuthorizationWidget extends StatelessWidget {
  const ReminderDeliveryAuthorizationWidget({required this.deliveryAuthorization, Key? key}) : super(key: key);
  final DeliveryAuthorization deliveryAuthorization;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => DeliveryAuthorizationDetailPage(
            deliveryAuthorizationId: deliveryAuthorization.id,
            isCharity: deliveryAuthorization.delivery?.type == DeliveryType.charity,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 19.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16.r,
          ),
          color: AppTheme.aljiroWhite,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 21.w,
            ),
            Assets.icons.icReminderAuthorization.image(
              width: 42.w,
              height: 50.h,
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: EasyRichText(
                LocaleKeys.delivery_authorization_reminder_receive_delivery_authorization.trans(
                  namedArgs: {
                    "phoneNumber": deliveryAuthorization.delivery?.receiver?.displayPhoneNumberAndName ?? "",
                    "cabinetName": deliveryAuthorization.delivery?.cabinet?.name ?? "",
                    "pocket":
                        "${LocaleKeys.delivery_authorization_pocket.trans()} ${deliveryAuthorization.delivery?.extra?.pocketExtra?.localId ?? ""}",
                  },
                ),
                defaultStyle: AppTheme.blackDark_14w400,
                patternList: [
                  EasyRichTextPattern(
                    targetString:
                        "${deliveryAuthorization.delivery?.cabinet?.name ?? ""} - ${LocaleKeys.delivery_authorization_pocket.trans()} ${deliveryAuthorization.delivery?.extra?.pocketExtra?.localId ?? ""}",
                    style: AppTheme.orange_14w600,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 17.w,
            ),
          ],
        ),
      ),
    );
  }
}
