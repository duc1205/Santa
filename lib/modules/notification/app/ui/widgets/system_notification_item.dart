import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page_viewmodel.dart';
import 'package:santapocket/modules/notification/domain/enums/notification_data_type.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:santapocket/storage/spref.dart';

class SystemNotificationItem extends StatelessWidget {
  final SystemNotification notification;
  final NotificationPageViewModel viewModel;
  final bool isUnRead;

  const SystemNotificationItem({
    required this.notification,
    required this.viewModel,
    required this.isUnRead,
    Key? key,
  }) : super(key: key);

  String get surpriseCampaignNotificationId {
    final campaign = notification.data.data?.data?['campaign'] as Map<String, dynamic>?;
    return campaign?['id'] as String;
  }

  NotificationDataType get notificationType => notification.data.data!.type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        switch (notificationType) {
          case NotificationDataType.marketingCampaignNotification:
            final marketingCampaignMap = notification.data.data?.data?["marketing_campaign"] as Map<String, dynamic>?;
            if (marketingCampaignMap != null) {
              final MarketingCampaign marketingCampaign = MarketingCampaign.fromJson(marketingCampaignMap);
              if (marketingCampaign.postUrl == null) {
                break;
              }
              if (marketingCampaign.postUrl!.contains("/topup")) {
                await Get.to(() => const PaymentPage());
              } else {
                String url = marketingCampaign.postUrl!;
                if (marketingCampaign.needAccessToken == true) {
                  final accessToken = await SPref.instance.getAccessToken();
                  url += "${url.contains("?") ? "&" : "?"}access_token=$accessToken";
                }
                await Get.to(() => WebViewPage(url: url));
              }
            }

            break;
          case NotificationDataType.surpriseCampaignNotification:
            final accessToken = await SPref.instance.getAccessToken();
            await Get.to(() =>
                WebViewPage(url: "${Config.baseSurpriseUrl}/campaign/$surpriseCampaignNotificationId?src=app&access_token=${(accessToken ?? "")}"));
            break;
          case NotificationDataType.marketNotification:
          case NotificationDataType.unknown:
          case NotificationDataType.userFreeUsageChanged:
          case NotificationDataType.userBalanceTransferred:
          case NotificationDataType.userBalanceChanged:
          case NotificationDataType.deliverySent:
          case NotificationDataType.deliveryFailed:
          case NotificationDataType.deliveryCanceled:
          case NotificationDataType.deliveryRefunded:
          case NotificationDataType.deliveryCharged:
          case NotificationDataType.deliveryCompleted:
          case NotificationDataType.deliveryAuthorizationCreated:
          case NotificationDataType.deliveryAuthorizationReceiverNotEnoughBalance:
          case NotificationDataType.userConeChangedNotification:
          case NotificationDataType.surpriseSampleRecalling:
          case NotificationDataType.deliveryReceiverChanged:
          case NotificationDataType.deliveryAuthorizationCanceled:
          case NotificationDataType.referralReferReward:
          case NotificationDataType.referralReferredReward:
          case NotificationDataType.systemMaintenanceNotification:
            break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
        color: isUnRead ? AppTheme.orange.withOpacity(0.1) : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Assets.icons.icNotificationDefault.image(
                  height: 28.h,
                  width: 28.w,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      notification.data.content.title,
                      style: AppTheme.blackDark_14w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  FormatHelper.formatDate("dd/MM/yyyy, HH:mm", notification.createdAt),
                  style: AppTheme.greyMedium_14,
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                notification.data.content.body,
                style: AppTheme.blackDark_14,
              ),
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
