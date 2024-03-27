// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cabinet _$CabinetFromJson(Map<String, dynamic> json) => Cabinet(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      isOnline: json['is_online'] as bool,
      locationId: json['location_id'] as int?,
      location: json['location'] == null ? null : Location.fromJson(json['location'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)?.map((e) => CabinetPhoto.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$CabinetToJson(Cabinet instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'location_id': instance.locationId,
      'is_online': instance.isOnline,
      'location': instance.location?.toJson(),
      'photos': instance.photos?.map((e) => e.toJson()).toList(),
    };
