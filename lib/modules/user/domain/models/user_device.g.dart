// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) => UserDevice(
      appVersion: json['app_version'] as String,
      os: json['os'] as String,
      osVersion: json['os_version'] as String?,
      deviceModel: json['device_model'] as String?,
      notificationPermission: json['notification_permission'] as bool,
    );

Map<String, dynamic> _$UserDeviceToJson(UserDevice instance) => <String, dynamic>{
      'app_version': instance.appVersion,
      'os': instance.os,
      'os_version': instance.osVersion,
      'device_model': instance.deviceModel,
      'notification_permission': instance.notificationPermission,
    };
