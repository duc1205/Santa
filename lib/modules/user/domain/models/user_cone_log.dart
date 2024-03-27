import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/user/domain/enums/user_cone_changing_type.dart';

part 'user_cone_log.g.dart';

@JsonSerializable()
class UserConeLog extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "cone")
  final int cone;
  @JsonKey(name: "old_cone")
  final int oldCone;
  @JsonKey(name: "type", unknownEnumValue: UserConeChangingType.unknown)
  final UserConeChangingType type;
  @JsonKey(name: "extra")
  final Map<String, dynamic>? extra;
  @JsonKey(name: "created_at")
  final DateTime createdAt;

  const UserConeLog({
    required this.id,
    required this.userId,
    required this.cone,
    required this.oldCone,
    required this.type,
    required this.extra,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id];

  factory UserConeLog.fromJson(Map<String, dynamic> json) => _$UserConeLogFromJson(json);

  Map<String, dynamic> toJson() => _$UserConeLogToJson(this);
}
