// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CabinetPhoto _$CabinetPhotoFromJson(Map<String, dynamic> json) => CabinetPhoto(
      id: json['id'] as int,
      cabinetId: json['cabinet_id'] as int,
      path: json['path'] as String,
      url: json['url'] as String,
      position: json['position'] as int,
    );

Map<String, dynamic> _$CabinetPhotoToJson(CabinetPhoto instance) => <String, dynamic>{
      'id': instance.id,
      'cabinet_id': instance.cabinetId,
      'path': instance.path,
      'url': instance.url,
      'position': instance.position,
    };
