// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocket_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PocketSize _$PocketSizeFromJson(Map<String, dynamic> json) => PocketSize(
      id: json['id'] as int,
      uuid: $enumDecode(_$PocketSizeUuidEnumMap, json['uuid'], unknownValue: PocketSizeUuid.unknown),
      name: json['name'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      availablePocketsCount: json['available_pockets_count'] as int?,
      pricing: json['pricing'] == null ? null : PocketPricing.fromJson(json['pricing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PocketSizeToJson(PocketSize instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': _$PocketSizeUuidEnumMap[instance.uuid]!,
      'name': instance.name,
      'width': instance.width,
      'height': instance.height,
      'available_pockets_count': instance.availablePocketsCount,
      'pricing': instance.pricing?.toJson(),
    };

const _$PocketSizeUuidEnumMap = {
  PocketSizeUuid.unknown: 'unknown',
  PocketSizeUuid.small: '126x428',
  PocketSizeUuid.medium: '244x428',
  PocketSizeUuid.large: '492x428',
};
