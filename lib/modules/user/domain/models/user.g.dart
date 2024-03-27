// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      phoneNumber: json['phone_number'] as String,
      name: json['name'] as String?,
      balance: json['balance'] as int,
      freeUsage: json['free_usage'] as int,
      locale: json['locale'] as String?,
      tutorialCompletedAt: json['tutorial_completed_at'] == null ? null : DateTime.parse(json['tutorial_completed_at'] as String),
      type: json['type'] as String?,
      coin: json['coin'] as int,
      tosAgreedAt: json['tos_agreed_at'] == null ? null : DateTime.parse(json['tos_agreed_at'] as String),
      referralCode: json['referral_code'] as String?,
      gem: json['gem'] as int,
      cone: json['cone'] as int,
      charityDeliveriesCount: json['charity_deliveries_count'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'phone_number': instance.phoneNumber,
      'name': instance.name,
      'balance': instance.balance,
      'free_usage': instance.freeUsage,
      'locale': instance.locale,
      'tutorial_completed_at': instance.tutorialCompletedAt?.toIso8601String(),
      'type': instance.type,
      'coin': instance.coin,
      'tos_agreed_at': instance.tosAgreedAt?.toIso8601String(),
      'referral_code': instance.referralCode,
      'gem': instance.gem,
      'cone': instance.cone,
      'charity_deliveries_count': instance.charityDeliveriesCount,
    };
