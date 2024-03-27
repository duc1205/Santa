import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
@CopyWith()
class Country extends Equatable {
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'phone_code')
  final String phoneCode;

  const Country({
    required this.code,
    required this.name,
    required this.phoneCode,
  });

  @override
  List<Object> get props => [code];

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
