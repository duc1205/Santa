import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instruction.g.dart';

@JsonSerializable()
class Instruction extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "position")
  final int position;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

  const Instruction({
    required this.id,
    this.name,
    required this.position,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object> get props => [id];

  factory Instruction.fromJson(Map<String, dynamic> json) => _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);
}
