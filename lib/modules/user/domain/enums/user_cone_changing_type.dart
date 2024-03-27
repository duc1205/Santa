import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';

enum UserConeChangingType {
  unknown,
  @JsonValue("delivery_sending_reward")
  deliverySendingReward,
  @JsonValue("delivery_receiving_reward")
  deliveryReceivingReward,
  @JsonValue("delivery_receiving")
  deliveryReceiving,
  @JsonValue("admin_adding")
  adminAdding,
  @JsonValue("refer_reward")
  referReward,
  @JsonValue("referred_reward")
  referredReward,
}

extension UserConeChangingTypeExt on UserConeChangingType {
  String getLabel() {
    switch (this) {
      case UserConeChangingType.adminAdding:
        return LocaleKeys.user_bonus.trans();
      case UserConeChangingType.deliveryReceivingReward:
        return LocaleKeys.user_top_up_xu.trans();
      case UserConeChangingType.deliverySendingReward:
      case UserConeChangingType.deliveryReceiving:
        return LocaleKeys.user_spent.trans();
      default:
        return '';
    }
  }
}
