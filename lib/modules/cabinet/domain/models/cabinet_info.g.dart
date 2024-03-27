// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CabinetInfo _$CabinetInfoFromJson(Map<String, dynamic> json) => CabinetInfo(
      id: json['cabinet_id'] as int,
      name: json['cabinet_name'] as String,
      receivableDeliveries: (json['receivable_deliveries'] as List<dynamic>?)?.map((e) => Delivery.fromJson(e as Map<String, dynamic>)).toList(),
      status: $enumDecode(_$CabinetStatusEnumMap, json['cabinet_status'], unknownValue: CabinetStatus.unknown),
      isOnline: json['cabinet_is_online'] as bool,
      receivableDeliveryAuthorizations: (json['receivable_delivery_authorizations'] as List<dynamic>?)
          ?.map((e) => DeliveryAuthorization.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CabinetInfoToJson(CabinetInfo instance) => <String, dynamic>{
      'cabinet_id': instance.id,
      'cabinet_name': instance.name,
      'cabinet_status': _$CabinetStatusEnumMap[instance.status]!,
      'cabinet_is_online': instance.isOnline,
      'receivable_deliveries': instance.receivableDeliveries?.map((e) => e.toJson()).toList(),
      'receivable_delivery_authorizations': instance.receivableDeliveryAuthorizations?.map((e) => e.toJson()).toList(),
    };

const _$CabinetStatusEnumMap = {
  CabinetStatus.unknown: 'unknown',
  CabinetStatus.inStock: 'in_stock',
  CabinetStatus.production: 'production',
  CabinetStatus.maintenance: 'maintenance',
};
