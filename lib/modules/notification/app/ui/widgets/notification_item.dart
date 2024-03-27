import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page_viewmodel.dart';
import 'package:santapocket/modules/notification/domain/enums/notification_data_type.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/transaction_history_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:santapocket/storage/spref.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;
  final NotificationPageViewModel viewModel;

  const NotificationItem({
    required this.notification,
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  int get deliveryId {
    final delivery = notification.data.data?.data?['delivery'] as Map<String, dynamic>?;
    return delivery?['id'] as int;
  }

  int get deliveryAuthorizationId {
    final deliveryAuthorization = notification.data.data?.data?['delivery_authorization'] as Map<String, dynamic>?;
    return deliveryAuthorization?['id'] as int;
  }

  int get deliveryIdNotBalance {
    final deliveryAuthorization = notification.data.data?.data?['delivery_authorization'] as Map<String, dynamic>?;
    return deliveryAuthorization?['delivery_id'] as int;
  }

  String get surpriseSampleRecallingUrl {
    final sample = notification.data.data?.data?['sample'] as Map<String, dynamic>?;
    return sample?['qr_url'] as String;
  }

  String get surpriseCampaignNotificationId {
    final campaign = notification.data.data?.data?['campaign'] as Map<String, dynamic>?;
    return campaign?['id'] as String;
  }

  bool get isSender {
    final sender = notification.data.data?.data?['sender'] as Map<String, dynamic>?;
    return viewModel.user?.phoneNumber == sender?["phone_number"];
  }

  NotificationDataType get notificationType => notification.data.data!.type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!notification.isRead) {
          await viewModel.markAsReadNotification(notification.id);
        }
        switch (notificationType) {
          case NotificationDataType.unknown:
          case NotificationDataType.userFreeUsageChanged:
            break;
          case NotificationDataType.userBalanceTransferred:
          case NotificationDataType.userBalanceChanged:
            await Get.to(() => const TransactionHistoryPage());
            break;
          case NotificationDataType.deliverySent:
          case NotificationDataType.deliveryFailed:
          case NotificationDataType.deliveryCanceled:
          case NotificationDataType.deliveryRefunded:
          case NotificationDataType.deliveryCharged:
          case NotificationDataType.deliveryCompleted:
            final delivery = await viewModel.getDelivery(deliveryId);
            if (delivery != null) {
              await Get.to(() => DeliveryDetailPage(
                    deliveryId: deliveryId,
                    isCharity: delivery.type == DeliveryType.charity,
                  ));
            }
            break;
          case NotificationDataType.deliveryAuthorizationCreated:
            final deliveryAuthorization = await viewModel.getAuthorizationDelivery(deliveryAuthorizationId);
            if (deliveryAuthorization != null) {
              await Get.to(() => DeliveryAuthorizationDetailPage(
                    deliveryAuthorizationId: deliveryAuthorizationId,
                    isCharity: deliveryAuthorization.delivery?.type == DeliveryType.charity,
                  ));
            }
            break;
          case NotificationDataType.deliveryAuthorizationReceiverNotEnoughBalance:
            final delivery = await viewModel.getDelivery(deliveryId);
            if (delivery != null) {
              await Get.to(() => DeliveryDetailPage(
                    deliveryId: deliveryIdNotBalance,
                    isCharity: delivery.type == DeliveryType.charity,
                  ));
            }
            break;
          case NotificationDataType.userConeChangedNotification:
            await Get.to(() => const TransactionHistoryPage(
                  isConeTab: true,
                ));

            break;
          case NotificationDataType.surpriseSampleRecalling:
            final accessToken = await SPref.instance.getAccessToken();
            await Get.to(() => WebViewPage(url: "$surpriseSampleRecallingUrl?src=app&access_token=${(accessToken ?? "")}"));
            break;
          case NotificationDataType.surpriseCampaignNotification:
            final accessToken = await SPref.instance.getAccessToken();
            await Get.to(() =>
                WebViewPage(url: "${Config.baseSurpriseUrl}/campaign/$surpriseCampaignNotificationId?src=app&access_token=${(accessToken ?? "")}"));
            break;
          case NotificationDataType.marketNotification:
            final marketServiceUrlTemp = (await locator<GetSettingUsecase>().run(Constants.marketServiceUrlSetting)).value as String;
            final accessToken = await SPref.instance.getAccessToken();
            await Get.to(() => WebViewPage(url: "$marketServiceUrlTemp?src=app&access_token=${(accessToken ?? "")}"));
            break;
          case NotificationDataType.deliveryReceiverChanged:
          case NotificationDataType.deliveryAuthorizationCanceled:
          case NotificationDataType.referralReferReward:
          case NotificationDataType.referralReferredReward:
          case NotificationDataType.systemMaintenanceNotification:
          case NotificationDataType.marketingCampaignNotification:
            break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
        color: notification.isRead ? Colors.white : AppTheme.orange.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showNotificationStatus(
                  Text(
                    FormatHelper.formatDate("dd/MM/yyyy, HH:mm", notification.createdAt),
                    style: AppTheme.greyMedium_14,
                  ),
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

  Widget _showNotificationStatus(Widget createdTimeWidget) {
    switch (notificationType) {
      case NotificationDataType.deliveryCompleted:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryCompleted.image(height: 26.h, width: 27.w),
            SizedBox(
              width: 9.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_delivery_completed.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliverySent:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliverySent.image(height: 25.h, width: 24.w),
            SizedBox(
              width: 9.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_delivery_sent.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryFailed:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryFail.image(
              height: 21.h,
              width: 23.w,
            ),
            SizedBox(
              width: 13.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_delivery_fail.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryCanceled:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryCancel.image(
              width: 23.w,
              height: 23.h,
            ),
            SizedBox(
              width: 14.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_delivery_cancel.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryCharged:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryCharged.image(
              width: 23.w,
              height: 23.h,
            ),
            SizedBox(
              width: 14.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_delivery_charged.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryRefunded:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryRefunded.image(
              width: 24.w,
              height: 25.h,
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_delivery_refund.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.userBalanceChanged:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icSantaCoin.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notification_santa_coin_changed.trans(),
                  style: AppTheme.blackDark_14w600,
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.userFreeUsageChanged:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationMoneyRounded.image(
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 179.w,
                  child: Text(
                    LocaleKeys.notification_free_usage_changed.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryAuthorizationCreated:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryAuthorized.image(
              height: 25.h,
              width: 26.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_delivery_authorized.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryAuthorizationReceiverNotEnoughBalance:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icSantaCoin.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_santa_coin_not_enough.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.userConeChangedNotification:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icConeV2.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_santa_cone.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.surpriseSampleRecalling:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icSurpriseSampleRecalling.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_sample_recalling.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.surpriseCampaignNotification:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icSurpriseCampaignNotification.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 179.w,
                  child: Text(
                    notification.data.content.title,
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryReceiverChanged:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationChangeReceiver.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_change_receiver.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.userBalanceTransferred:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSender
                ? Assets.icons.icNotificationTransferSent.image(
                    height: 28.h,
                    width: 28.w,
                  )
                : Assets.icons.icNotificationTransferReceive.image(
                    height: 28.h,
                    width: 28.w,
                  ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_santa_coin_transferred.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.deliveryAuthorizationCanceled:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDeliveryCancel.image(
              width: 23.w,
              height: 23.h,
            ),
            SizedBox(
              width: 14.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.notification_authorized_delivery_canceled.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                  createdTimeWidget,
                ],
              ),
            ),
          ],
        );
      case NotificationDataType.referralReferReward:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icReferral.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      LocaleKeys.notification_referral_sucess.trans(),
                      style: AppTheme.blackDark_14w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  createdTimeWidget,
                ],
              ),
            ),
          ],
        );
      case NotificationDataType.referralReferredReward:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icReferral.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.notification_welcome_to_santa.trans(),
                    style: AppTheme.blackDark_14w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  createdTimeWidget,
                ],
              ),
            ),
          ],
        );
      case NotificationDataType.systemMaintenanceNotification:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDefault.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    notification.data.content.title,
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
      case NotificationDataType.marketingCampaignNotification:
      case NotificationDataType.marketNotification:
      case NotificationDataType.unknown:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.icons.icNotificationDefault.image(
              height: 28.h,
              width: 28.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    LocaleKeys.notification_notification.trans(),
                    style: AppTheme.blackDark_14w600,
                  ),
                ),
                createdTimeWidget,
              ],
            ),
          ],
        );
    }
  }
}
