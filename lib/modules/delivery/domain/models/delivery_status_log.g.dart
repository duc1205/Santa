// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_status_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryStatusLog _$DeliveryStatusLogFromJson(Map<String, dynamic> json) => DeliveryStatusLog(
      id: json['id'] as int,
      status: $enumDecode(_$DeliveryStatusEnumMap, json['status'], unknownValue: DeliveryStatus.unknown),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DeliveryStatusLogToJson(DeliveryStatusLog instance) => <String, dynamic>{
      'id': instance.id,
      'status': _$DeliveryStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.unknown: 'unknown',
  DeliveryStatus.created: 'created',
  DeliveryStatus.sending: 'sending',
  DeliveryStatus.sent: 'sent',
  DeliveryStatus.receiving: 'receiving',
  DeliveryStatus.received: 'received',
  DeliveryStatus.completed: 'completed',
  DeliveryStatus.failed: 'failed',
  DeliveryStatus.canceled: 'canceled',
};
