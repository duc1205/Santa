// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_notification.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SystemNotificationCWProxy {
  SystemNotification id(String id);

  SystemNotification topic(String topic);

  SystemNotification data(NotificationData data);

  SystemNotification createdAt(DateTime createdAt);

  SystemNotification updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SystemNotification(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SystemNotification(...).copyWith(id: 12, name: "My name")
  /// ````
  SystemNotification call({
    String? id,
    String? topic,
    NotificationData? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSystemNotification.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSystemNotification.copyWith.fieldName(...)`
class _$SystemNotificationCWProxyImpl implements _$SystemNotificationCWProxy {
  const _$SystemNotificationCWProxyImpl(this._value);

  final SystemNotification _value;

  @override
  SystemNotification id(String id) => this(id: id);

  @override
  SystemNotification topic(String topic) => this(topic: topic);

  @override
  SystemNotification data(NotificationData data) => this(data: data);

  @override
  SystemNotification createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  SystemNotification updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SystemNotification(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SystemNotification(...).copyWith(id: 12, name: "My name")
  /// ````
  SystemNotification call({
    Object? id = const $CopyWithPlaceholder(),
    Object? topic = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return SystemNotification(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      topic: topic == const $CopyWithPlaceholder() || topic == null
          // ignore: unnecessary_non_null_assertion
          ? _value.topic!
          // ignore: cast_nullable_to_non_nullable
          : topic as String,
      data: data == const $CopyWithPlaceholder() || data == null
          // ignore: unnecessary_non_null_assertion
          ? _value.data!
          // ignore: cast_nullable_to_non_nullable
          : data as NotificationData,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.createdAt!
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder() || updatedAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.updatedAt!
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $SystemNotificationCopyWith on SystemNotification {
  /// Returns a callable class that can be used as follows: `instanceOfSystemNotification.copyWith(...)` or like so:`instanceOfSystemNotification.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SystemNotificationCWProxy get copyWith => _$SystemNotificationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemNotification _$SystemNotificationFromJson(Map<String, dynamic> json) => SystemNotification(
      id: const StringConverter().fromJson(json['id']),
      topic: json['topic'] as String,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SystemNotificationToJson(SystemNotification instance) => <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'topic': instance.topic,
      'data': instance.data.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
