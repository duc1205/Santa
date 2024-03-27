import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pocket_pricing.g.dart';

@JsonSerializable()
class PocketPricing extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "size_id")
  final int sizeId;
  @JsonKey(name: "sending_price")
  final int sendingPrice;

  const PocketPricing({
    required this.id,
    required this.sizeId,
    required this.sendingPrice,
  });

  @override
  List<Object> get props => [id];

  factory PocketPricing.fromJson(Map<String, dynamic> json) => _$PocketPricingFromJson(json);

  Map<String, dynamic> toJson() => _$PocketPricingToJson(this);
}
