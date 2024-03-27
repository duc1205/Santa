import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/cabinet/domain/enums/pocket_size_uuid.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_pricing.dart';

part 'pocket_size.g.dart';

@JsonSerializable()
class PocketSize extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "uuid", unknownEnumValue: PocketSizeUuid.unknown)
  final PocketSizeUuid uuid;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "width")
  final int width;
  @JsonKey(name: "height")
  final int height;

  ///
  /// Aggregates
  ///

  @JsonKey(name: "available_pockets_count")
  final int? availablePocketsCount;

  ///
  /// Relations
  ///

  @JsonKey(name: "pricing")
  final PocketPricing? pricing;

  const PocketSize({
    required this.id,
    required this.uuid,
    required this.name,
    required this.width,
    required this.height,
    this.availablePocketsCount,
    this.pricing,
  });

  @override
  List<Object> get props => [id];

  factory PocketSize.fromJson(Map<String, dynamic> json) => _$PocketSizeFromJson(json);

  Map<String, dynamic> toJson() => _$PocketSizeToJson(this);
}
