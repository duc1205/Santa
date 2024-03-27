// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceLog _$BalanceLogFromJson(Map<String, dynamic> json) => BalanceLog(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      oldBalance: json['old_balance'] as int,
      balance: json['balance'] as int,
      type: $enumDecode(_$UserBalanceChangingTypeEnumMap, json['type'], unknownValue: UserBalanceChangingType.unknown),
      extra: json['extra'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BalanceLogToJson(BalanceLog instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'old_balance': instance.oldBalance,
      'balance': instance.balance,
      'type': _$UserBalanceChangingTypeEnumMap[instance.type]!,
      'extra': instance.extra,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$UserBalanceChangingTypeEnumMap = {
  UserBalanceChangingType.unknown: 'unknown',
  UserBalanceChangingType.newUser: 'new_user',
  UserBalanceChangingType.adminAdding: 'admin_adding',
  UserBalanceChangingType.topUp: 'topup',
  UserBalanceChangingType.deliveryReceiving: 'delivery_receiving',
  UserBalanceChangingType.deliverySending: 'delivery_sending',
  UserBalanceChangingType.deliveryRefund: 'delivery_refund',
  UserBalanceChangingType.deliveryRent: 'delivery_rent',
  UserBalanceChangingType.deliveryCharge: 'delivery_charge',
  UserBalanceChangingType.adminTransfer: 'admin_transfer',
};
