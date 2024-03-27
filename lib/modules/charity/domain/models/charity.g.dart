// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Charity _$CharityFromJson(Map<String, dynamic> json) => Charity(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      gratefulMessage: json['grateful_message'] as String?,
      description: json['description'] as String?,
      user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
      location: json['location'] == null ? null : Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharityToJson(Charity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'icon_url': instance.iconUrl,
      'grateful_message': instance.gratefulMessage,
      'description': instance.description,
      'user': instance.user?.toJson(),
      'location': instance.location?.toJson(),
    };
