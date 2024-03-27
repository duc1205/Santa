// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) => NotificationData(
      content: NotificationDataContent.fromJson(json['content'] as Map<String, dynamic>),
      data: json['data'] == null ? null : NotificationDataData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) => <String, dynamic>{
      'content': instance.content.toJson(),
      'data': instance.data?.toJson(),
    };
