// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pocket _$PocketFromJson(Map<String, dynamic> json) => Pocket(
      id: json['id'] as int,
      name: json['name'] as String,
      status: $enumDecode(_$PocketStatusEnumMap, json['status'], unknownValue: PocketStatus.unknown),
      localId: json['local_id'] as int?,
      cabinetId: json['cabinet_id'] as int?,
      sizeId: json['size_id'] as int,
      size: json['size'] == null ? null : PocketSize.fromJson(json['size'] as Map<String, dynamic>),
      cabinet: json['cabinet_list'] == null ? null : Cabinet.fromJson(json['cabinet_list'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PocketToJson(Pocket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': _$PocketStatusEnumMap[instance.status]!,
      'local_id': instance.localId,
      'cabinet_id': instance.cabinetId,
      'size_id': instance.sizeId,
      'cabinet_list': instance.cabinet?.toJson(),
      'size': instance.size?.toJson(),
    };

const _$PocketStatusEnumMap = {
  PocketStatus.unknown: 'unknown',
  PocketStatus.opening: 'opening',
  PocketStatus.opened: 'opened',
  PocketStatus.closing: 'closing',
  PocketStatus.closed: 'closed',
};
