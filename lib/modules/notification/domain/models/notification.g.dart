// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationCWProxy {
  Notification id(String id);

  Notification notifiableId(String notifiableId);

  Notification data(NotificationData data);

  Notification createdAt(DateTime createdAt);

  Notification updatedAt(DateTime updatedAt);

  Notification readAt(DateTime? readAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Notification(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Notification(...).copyWith(id: 12, name: "My name")
  /// ````
  Notification call({
    String? id,
    String? notifiableId,
    NotificationData? data,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotification.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotification.copyWith.fieldName(...)`
class _$NotificationCWProxyImpl implements _$NotificationCWProxy {
  const _$NotificationCWProxyImpl(this._value);

  final Notification _value;

  @override
  Notification id(String id) => this(id: id);

  @override
  Notification notifiableId(String notifiableId) => this(notifiableId: notifiableId);

  @override
  Notification data(NotificationData data) => this(data: data);

  @override
  Notification createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Notification updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  Notification readAt(DateTime? readAt) => this(readAt: readAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Notification(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Notification(...).copyWith(id: 12, name: "My name")
  /// ````
  Notification call({
    Object? id = const $CopyWithPlaceholder(),
    Object? notifiableId = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? readAt = const $CopyWithPlaceholder(),
  }) {
    return Notification(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      notifiableId: notifiableId == const $CopyWithPlaceholder() || notifiableId == null
          // ignore: unnecessary_non_null_assertion
          ? _value.notifiableId!
          // ignore: cast_nullable_to_non_nullable
          : notifiableId as String,
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
      readAt: readAt == const $CopyWithPlaceholder()
          ? _value.readAt
          // ignore: cast_nullable_to_non_nullable
          : readAt as DateTime?,
    );
  }
}

extension $NotificationCopyWith on Notification {
  /// Returns a callable class that can be used as follows: `instanceOfNotification.copyWith(...)` or like so:`instanceOfNotification.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationCWProxy get copyWith => _$NotificationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: const StringConverter().fromJson(json['id']),
      notifiableId: json['notifiable_id'] as String,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at'] as String),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) => <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'notifiable_id': instance.notifiableId,
      'data': instance.data.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
    };
