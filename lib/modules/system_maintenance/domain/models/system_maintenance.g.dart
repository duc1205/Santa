// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_maintenance.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SystemMaintenanceCWProxy {
  SystemMaintenance id(int id);

  SystemMaintenance name(String name);

  SystemMaintenance content(String content);

  SystemMaintenance startedAt(DateTime startedAt);

  SystemMaintenance endedAt(DateTime endedAt);

  SystemMaintenance createdAt(DateTime createdAt);

  SystemMaintenance updatedAt(DateTime updatedAt);

  SystemMaintenance status(SystemMaintenanceStatus status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SystemMaintenance(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SystemMaintenance(...).copyWith(id: 12, name: "My name")
  /// ````
  SystemMaintenance call({
    int? id,
    String? name,
    String? content,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    SystemMaintenanceStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSystemMaintenance.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSystemMaintenance.copyWith.fieldName(...)`
class _$SystemMaintenanceCWProxyImpl implements _$SystemMaintenanceCWProxy {
  const _$SystemMaintenanceCWProxyImpl(this._value);

  final SystemMaintenance _value;

  @override
  SystemMaintenance id(int id) => this(id: id);

  @override
  SystemMaintenance name(String name) => this(name: name);

  @override
  SystemMaintenance content(String content) => this(content: content);

  @override
  SystemMaintenance startedAt(DateTime startedAt) => this(startedAt: startedAt);

  @override
  SystemMaintenance endedAt(DateTime endedAt) => this(endedAt: endedAt);

  @override
  SystemMaintenance createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  SystemMaintenance updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  SystemMaintenance status(SystemMaintenanceStatus status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SystemMaintenance(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SystemMaintenance(...).copyWith(id: 12, name: "My name")
  /// ````
  SystemMaintenance call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? endedAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return SystemMaintenance(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          // ignore: unnecessary_non_null_assertion
          ? _value.name!
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      content: content == const $CopyWithPlaceholder() || content == null
          // ignore: unnecessary_non_null_assertion
          ? _value.content!
          // ignore: cast_nullable_to_non_nullable
          : content as String,
      startedAt: startedAt == const $CopyWithPlaceholder() || startedAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.startedAt!
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime,
      endedAt: endedAt == const $CopyWithPlaceholder() || endedAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.endedAt!
          // ignore: cast_nullable_to_non_nullable
          : endedAt as DateTime,
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
      status: status == const $CopyWithPlaceholder() || status == null
          // ignore: unnecessary_non_null_assertion
          ? _value.status!
          // ignore: cast_nullable_to_non_nullable
          : status as SystemMaintenanceStatus,
    );
  }
}

extension $SystemMaintenanceCopyWith on SystemMaintenance {
  /// Returns a callable class that can be used as follows: `instanceOfSystemMaintenance.copyWith(...)` or like so:`instanceOfSystemMaintenance.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SystemMaintenanceCWProxy get copyWith => _$SystemMaintenanceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemMaintenance _$SystemMaintenanceFromJson(Map<String, dynamic> json) => SystemMaintenance(
      id: json['id'] as int,
      name: json['name'] as String,
      content: json['content'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      status: $enumDecode(_$SystemMaintenanceStatusEnumMap, json['status'], unknownValue: SystemMaintenanceStatus.unknown),
    );

Map<String, dynamic> _$SystemMaintenanceToJson(SystemMaintenance instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'content': instance.content,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'status': _$SystemMaintenanceStatusEnumMap[instance.status]!,
    };

const _$SystemMaintenanceStatusEnumMap = {
  SystemMaintenanceStatus.unknown: 'unknown',
  SystemMaintenanceStatus.created: 'created',
  SystemMaintenanceStatus.softMaintaining: 'soft_maintaining',
  SystemMaintenanceStatus.maintaining: 'maintaining',
  SystemMaintenanceStatus.finished: 'finished',
};
