// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_public_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPublicInfo _$UserPublicInfoFromJson(Map<String, dynamic> json) => UserPublicInfo(
      id: json['id'] as int,
      name: json['name'] as String?,
      lastSeen: json['last_seen'] == null ? null : DateTime.parse(json['last_seen'] as String),
    );

Map<String, dynamic> _$UserPublicInfoToJson(UserPublicInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'last_seen': instance.lastSeen?.toIso8601String(),
    };
