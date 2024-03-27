import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

part 'volunteer.g.dart';

@JsonSerializable()
class Volunteer extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "phone_number")
  final String phoneNumber;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "user_id")
  final int userId;

  // Relation
  final User user;

  const Volunteer({
    required this.id,
    required this.phoneNumber,
    required this.userId,
    required this.user,
    this.name,
  });

  @override
  List<Object?> get props => [id];

  factory Volunteer.fromJson(Map<String, dynamic> json) => _$VolunteerFromJson(json);

  Map<String, dynamic> toJson() => _$VolunteerToJson(this);
}
