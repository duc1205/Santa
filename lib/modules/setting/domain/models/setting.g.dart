// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingCWProxy {
  Setting id(int id);

  Setting key(String key);

  Setting value(dynamic value);

  Setting type(String type);

  Setting createdAt(DateTime createdAt);

  Setting updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Setting(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Setting(...).copyWith(id: 12, name: "My name")
  /// ````
  Setting call({
    int? id,
    String? key,
    dynamic? value,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetting.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetting.copyWith.fieldName(...)`
class _$SettingCWProxyImpl implements _$SettingCWProxy {
  const _$SettingCWProxyImpl(this._value);

  final Setting _value;

  @override
  Setting id(int id) => this(id: id);

  @override
  Setting key(String key) => this(key: key);

  @override
  Setting value(dynamic value) => this(value: value);

  @override
  Setting type(String type) => this(type: type);

  @override
  Setting createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Setting updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Setting(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Setting(...).copyWith(id: 12, name: "My name")
  /// ````
  Setting call({
    Object? id = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return Setting(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      key: key == const $CopyWithPlaceholder() || key == null
          // ignore: unnecessary_non_null_assertion
          ? _value.key!
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      value: value == const $CopyWithPlaceholder() || value == null
          // ignore: unnecessary_non_null_assertion
          ? _value.value!
          // ignore: cast_nullable_to_non_nullable
          : value as dynamic,
      type: type == const $CopyWithPlaceholder() || type == null
          // ignore: unnecessary_non_null_assertion
          ? _value.type!
          // ignore: cast_nullable_to_non_nullable
          : type as String,
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

extension $SettingCopyWith on Setting {
  /// Returns a callable class that can be used as follows: `instanceOfSetting.copyWith(...)` or like so:`instanceOfSetting.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingCWProxy get copyWith => _$SettingCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      id: json['id'] as int,
      key: json['key'] as String,
      value: json['value'],
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
