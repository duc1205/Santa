import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/retrofit/entities/location/location.dart';

part 'charity.g.dart';

@JsonSerializable()
class Charity extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "icon_url")
  final String? iconUrl;
  @JsonKey(name: "grateful_message")
  final String? gratefulMessage;
  @JsonKey(name: "description")
  final String? description;

  /// Relations

  @JsonKey(name: "user")
  final User? user;
  @JsonKey(name: "location")
  final Location? location;

  const Charity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.iconUrl,
    this.gratefulMessage,
    this.description,
    this.user,
    this.location,
  });

  @override
  List<Object?> get props => [id];

  factory Charity.fromJson(Map<String, dynamic> json) => _$CharityFromJson(json);

  Map<String, dynamic> toJson() => _$CharityToJson(this);
}
