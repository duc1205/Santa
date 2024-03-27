import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'charity_campaign_image.g.dart';

@JsonSerializable()
class CharityCampaignImage extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "url")
  final String url;

  const CharityCampaignImage({
    required this.id,
    required this.url,
  });

  @override
  List<Object?> get props => [id];

  factory CharityCampaignImage.fromJson(Map<String, dynamic> json) => _$CharityCampaignImageFromJson(json);

  Map<String, dynamic> toJson() => _$CharityCampaignImageToJson(this);
}
