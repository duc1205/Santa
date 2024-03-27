import 'package:json_annotation/json_annotation.dart';

enum NotificationDataType {
  unknown,

  /// User
  @JsonValue("user_balance_changed")
  userBalanceChanged,
  @JsonValue('user_free_usage_changed')
  userFreeUsageChanged,
  @JsonValue('user_cone_changed_notification')
  userConeChangedNotification,
  @JsonValue('user_balance_transferred')
  userBalanceTransferred,
  @JsonValue('referral_new_user_refer_reward')
  referralReferReward,
  @JsonValue('referral_new_user_referred_reward')
  referralReferredReward,

  /// Delivery
  @JsonValue("delivery_sent")
  deliverySent,
  @JsonValue("delivery_failed")
  deliveryFailed,
  @JsonValue("delivery_canceled")
  deliveryCanceled,
  @JsonValue("delivery_refunded")
  deliveryRefunded,
  @JsonValue('delivery_charged')
  deliveryCharged,
  @JsonValue('delivery_completed')
  deliveryCompleted,
  @JsonValue('delivery_receiver_changed')
  deliveryReceiverChanged,
  @JsonValue('delivery_authorization_canceled')
  deliveryAuthorizationCanceled,

  /// Delivery Authorization
  @JsonValue('delivery_authorization_created')
  deliveryAuthorizationCreated,
  @JsonValue('delivery_authorization_receiver_not_enough_balance')
  deliveryAuthorizationReceiverNotEnoughBalance,

  //surprise
  @JsonValue('surprise_sample_recalling')
  surpriseSampleRecalling,
  @JsonValue('surprise_campaign_notification')
  surpriseCampaignNotification,

  //system
  @JsonValue('system_maintenance_notification')
  systemMaintenanceNotification,

  //market
  @JsonValue("market_notification")
  marketNotification,

  //campaign
  @JsonValue("marketing_campaign_notification")
  marketingCampaignNotification,
}
