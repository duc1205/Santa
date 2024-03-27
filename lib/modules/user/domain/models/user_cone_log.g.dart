// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cone_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConeLog _$UserConeLogFromJson(Map<String, dynamic> json) => UserConeLog(
      id: json['id'] as String,
      userId: json['user_id'] as int,
      cone: json['cone'] as int,
      oldCone: json['old_cone'] as int,
      type: $enumDecode(_$UserConeChangingTypeEnumMap, json['type'], unknownValue: UserConeChangingType.unknown),
      extra: json['extra'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserConeLogToJson(UserConeLog instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'cone': instance.cone,
      'old_cone': instance.oldCone,
      'type': _$UserConeChangingTypeEnumMap[instance.type]!,
      'extra': instance.extra,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$UserConeChangingTypeEnumMap = {
  UserConeChangingType.unknown: 'unknown',
  UserConeChangingType.deliverySendingReward: 'delivery_sending_reward',
  UserConeChangingType.deliveryReceivingReward: 'delivery_receiving_reward',
  UserConeChangingType.deliveryReceiving: 'delivery_receiving',
  UserConeChangingType.adminAdding: 'admin_adding',
  UserConeChangingType.referReward: 'refer_reward',
  UserConeChangingType.referredReward: 'referred_reward',
};
