import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_photo.dart';
import 'package:santapocket/retrofit/entities/location/location.dart';

part 'cabinet.g.dart';

@JsonSerializable()
class Cabinet extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "uuid")
  final String uuid;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "location_id")
  final int? locationId;
  @JsonKey(name: "is_online")
  final bool isOnline;

  ///
  /// Relations
  ///

  @JsonKey(name: "location")
  final Location? location;

  @JsonKey(name: "photos")
  final List<CabinetPhoto>? photos;

  const Cabinet({
    required this.id,
    required this.uuid,
    required this.name,
    required this.isOnline,
    this.locationId,
    this.location,
    this.photos,
  });

  @override
  List<Object> get props => [id];

  factory Cabinet.fromJson(Map<String, dynamic> json) => _$CabinetFromJson(json);

  Map<String, dynamic> toJson() => _$CabinetToJson(this);
}
