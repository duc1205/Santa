// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDataData _$NotificationDataDataFromJson(Map<String, dynamic> json) => NotificationDataData(
      type: $enumDecode(_$NotificationDataTypeEnumMap, json['type'], unknownValue: NotificationDataType.unknown),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationDataDataToJson(NotificationDataData instance) => <String, dynamic>{
      'type': _$NotificationDataTypeEnumMap[instance.type]!,
      'data': instance.data,
    };

const _$NotificationDataTypeEnumMap = {
  NotificationDataType.unknown: 'unknown',
  NotificationDataType.userBalanceChanged: 'user_balance_changed',
  NotificationDataType.userFreeUsageChanged: 'user_free_usage_changed',
  NotificationDataType.userConeChangedNotification: 'user_cone_changed_notification',
  NotificationDataType.userBalanceTransferred: 'user_balance_transferred',
  NotificationDataType.referralReferReward: 'referral_new_user_refer_reward',
  NotificationDataType.referralReferredReward: 'referral_new_user_referred_reward',
  NotificationDataType.deliverySent: 'delivery_sent',
  NotificationDataType.deliveryFailed: 'delivery_failed',
  NotificationDataType.deliveryCanceled: 'delivery_canceled',
  NotificationDataType.deliveryRefunded: 'delivery_refunded',
  NotificationDataType.deliveryCharged: 'delivery_charged',
  NotificationDataType.deliveryCompleted: 'delivery_completed',
  NotificationDataType.deliveryReceiverChanged: 'delivery_receiver_changed',
  NotificationDataType.deliveryAuthorizationCanceled: 'delivery_authorization_canceled',
  NotificationDataType.deliveryAuthorizationCreated: 'delivery_authorization_created',
  NotificationDataType.deliveryAuthorizationReceiverNotEnoughBalance: 'delivery_authorization_receiver_not_enough_balance',
  NotificationDataType.surpriseSampleRecalling: 'surprise_sample_recalling',
  NotificationDataType.surpriseCampaignNotification: 'surprise_campaign_notification',
  NotificationDataType.systemMaintenanceNotification: 'system_maintenance_notification',
  NotificationDataType.marketNotification: 'market_notification',
  NotificationDataType.marketingCampaignNotification: 'marketing_campaign_notification',
};
