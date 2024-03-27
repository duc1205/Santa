import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_public_info.g.dart';

@JsonSerializable()
class UserPublicInfo extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "last_seen")
  final DateTime? lastSeen;

  const UserPublicInfo({
    required this.id,
    this.name,
    this.lastSeen,
  });

  @override
  List<Object> get props => [id];

  factory UserPublicInfo.fromJson(Map<String, dynamic> json) => _$UserPublicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserPublicInfoToJson(this);
}
