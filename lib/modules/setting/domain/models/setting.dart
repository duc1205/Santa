import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@CopyWith()
@JsonSerializable()
class Setting extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "key")
  final String key;
  @JsonKey(name: "value")
  final dynamic value;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const Setting({
    required this.id,
    required this.key,
    this.value,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id];

  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);

  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
