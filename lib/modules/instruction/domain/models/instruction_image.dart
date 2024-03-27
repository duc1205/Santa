import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instruction_image.g.dart';

@JsonSerializable()
class InstructionImage extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "locale")
  final String? locale;
  @JsonKey(name: "position")
  final int? position;
  @JsonKey(name: "instruction_id")
  final int instructionId;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

  const InstructionImage({
    required this.id,
    this.url,
    this.locale,
    this.position,
    required this.instructionId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object> get props => [id];

  factory InstructionImage.fromJson(Map<String, dynamic> json) => _$InstructionImageFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionImageToJson(this);
}
