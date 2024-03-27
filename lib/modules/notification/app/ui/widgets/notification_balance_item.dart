import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page_viewmodel.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/transaction_history_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class NotificationBalanceItem extends StatelessWidget {
  const NotificationBalanceItem({required this.notification, required this.viewModel, Key? key}) : super(key: key);

  final Notification notification;
  final NotificationPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!notification.isRead) {
          await viewModel.markAsReadNotification(notification.id);
        }
        await Get.to(() => const TransactionHistoryPage());
      },
      child: Container(
        width: double.infinity,
        color: notification.isRead ? Colors.white : AppTheme.orange.withOpacity(0.1),
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Assets.icons.icNotificationMoneyRounded.image(),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  LocaleKeys.notification_balance_changed.trans(),
                  style: AppTheme.blackDark_14bold,
                ),
                const Spacer(),
                Text(
                  FormatHelper.formatDate("dd/MM/yyyy, HH:mm", notification.createdAt),
                  style: AppTheme.greyMedium_14,
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              notification.data.content.body,
              style: AppTheme.blackDark_14,
            ),
            SizedBox(
              height: 14.h,
            ),
            Divider(
              thickness: 1.w,
              height: 1.h,
              color: AppTheme.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
