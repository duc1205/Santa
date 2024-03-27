// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryAuthorization _$DeliveryAuthorizationFromJson(Map<String, dynamic> json) => DeliveryAuthorization(
      id: json['id'] as int,
      deliveryId: json['delivery_id'] as int,
      isReceived: json['is_received'] as bool,
      userId: json['user_id'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      status: $enumDecode(_$DeliveryAuthorizationStatusEnumMap, json['status'], unknownValue: DeliveryAuthorizationStatus.unknown),
      user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
      delivery: json['delivery'] == null ? null : Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryAuthorizationToJson(DeliveryAuthorization instance) => <String, dynamic>{
      'id': instance.id,
      'delivery_id': instance.deliveryId,
      'user_id': instance.userId,
      'is_received': instance.isReceived,
      'status': _$DeliveryAuthorizationStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user?.toJson(),
      'delivery': instance.delivery?.toJson(),
    };

const _$DeliveryAuthorizationStatusEnumMap = {
  DeliveryAuthorizationStatus.unknown: 'unknown',
  DeliveryAuthorizationStatus.created: 'created',
  DeliveryAuthorizationStatus.received: 'received',
  DeliveryAuthorizationStatus.canceled: 'canceled',
};
