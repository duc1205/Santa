// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volunteer _$VolunteerFromJson(Map<String, dynamic> json) => Volunteer(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      userId: json['user_id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$VolunteerToJson(Volunteer instance) => <String, dynamic>{
      'id': instance.id,
      'phone_number': instance.phoneNumber,
      'name': instance.name,
      'user_id': instance.userId,
      'user': instance.user.toJson(),
    };
