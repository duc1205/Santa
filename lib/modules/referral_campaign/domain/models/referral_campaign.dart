import 'package:json_annotation/json_annotation.dart';

part 'referral_campaign.g.dart';

@JsonSerializable()
class ReferralCampaign {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "info_url")
  final String? infoUrl;
  @JsonKey(name: "descriptions")
  final List<String>? descriptions;
  @JsonKey(name: "started_at")
  final DateTime? startedAt;
  @JsonKey(name: "ended_at")
  final DateTime? endedAt;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "refer_cone_reward")
  final int? referConeReward;
  @JsonKey(name: "referred_cone_reward")
  final int? referredConeReward;
  @JsonKey(name: "refer_free_usage_reward")
  final int? referFreeUsageReward;
  @JsonKey(name: "referred_free_usage_reward")
  final int? referredFreeUsageReward;

  const ReferralCampaign({
    required this.id,
    this.name,
    this.infoUrl,
    this.descriptions,
    this.startedAt,
    this.endedAt,
    this.updatedAt,
    this.createdAt,
    this.referConeReward,
    this.referredConeReward,
    this.referFreeUsageReward,
    this.referredFreeUsageReward,
  });

  factory ReferralCampaign.fromJson(Map<String, dynamic> json) => _$ReferralCampaignFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralCampaignToJson(this);
}
