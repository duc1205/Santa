import 'package:json_annotation/json_annotation.dart';

part 'marketing_campaign.g.dart';

@JsonSerializable()
class MarketingCampaign {
  final int id;
  final String? name;
  @JsonKey(name: "app_banner_url")
  final String? bannerUrl;
  @JsonKey(name: "app_popup_url")
  final String? popupUrl;
  @JsonKey(name: "post_url")
  final String? postUrl;
  @JsonKey(name: "started_at")
  final DateTime? startedAt;
  @JsonKey(name: "ended_at")
  final DateTime? endedAt;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "need_access_token")
  final bool? needAccessToken;

  const MarketingCampaign({
    required this.id,
    this.name,
    this.bannerUrl,
    this.popupUrl,
    this.postUrl,
    this.startedAt,
    this.endedAt,
    this.updatedAt,
    this.createdAt,
    this.needAccessToken,
  });

  factory MarketingCampaign.fromJson(Map<String, dynamic> json) => _$MarketingCampaignFromJson(json);

  Map<String, dynamic> toJson() => _$MarketingCampaignToJson(this);
}
