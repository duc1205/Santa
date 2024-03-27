// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CountryCWProxy {
  Country code(String code);

  Country name(String name);

  Country phoneCode(String phoneCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Country(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Country(...).copyWith(id: 12, name: "My name")
  /// ````
  Country call({
    String? code,
    String? name,
    String? phoneCode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCountry.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCountry.copyWith.fieldName(...)`
class _$CountryCWProxyImpl implements _$CountryCWProxy {
  const _$CountryCWProxyImpl(this._value);

  final Country _value;

  @override
  Country code(String code) => this(code: code);

  @override
  Country name(String name) => this(name: name);

  @override
  Country phoneCode(String phoneCode) => this(phoneCode: phoneCode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Country(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Country(...).copyWith(id: 12, name: "My name")
  /// ````
  Country call({
    Object? code = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phoneCode = const $CopyWithPlaceholder(),
  }) {
    return Country(
      code: code == const $CopyWithPlaceholder() || code == null
          // ignore: unnecessary_non_null_assertion
          ? _value.code!
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      name: name == const $CopyWithPlaceholder() || name == null
          // ignore: unnecessary_non_null_assertion
          ? _value.name!
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      phoneCode: phoneCode == const $CopyWithPlaceholder() || phoneCode == null
          // ignore: unnecessary_non_null_assertion
          ? _value.phoneCode!
          // ignore: cast_nullable_to_non_nullable
          : phoneCode as String,
    );
  }
}

extension $CountryCopyWith on Country {
  /// Returns a callable class that can be used as follows: `instanceOfCountry.copyWith(...)` or like so:`instanceOfCountry.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CountryCWProxy get copyWith => _$CountryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      code: json['code'] as String,
      name: json['name'] as String,
      phoneCode: json['phone_code'] as String,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'phone_code': instance.phoneCode,
    };
