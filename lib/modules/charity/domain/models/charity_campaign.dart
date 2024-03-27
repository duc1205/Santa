import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/charity/domain/enums/charity_campaign_status.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';

part 'charity_campaign.g.dart';

@JsonSerializable()
class CharityCampaign extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "charity_id")
  final String charityId;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "status", unknownEnumValue: CharityCampaignStatus.unknown)
  final CharityCampaignStatus status;
  @JsonKey(name: "gift_type")
  final String? giftType;
  @JsonKey(name: "beneficiary")
  final String? beneficiary;
  @JsonKey(name: "info_url")
  final String? infoUrl;
  @JsonKey(name: "started_at")
  final DateTime? startedAt;
  @JsonKey(name: "ended_at")
  final DateTime? endedAt;
  @JsonKey(name: "grateful_message")
  final String? gratefulMessage;

  // Relations

  @JsonKey(name: "charity")
  final Charity? charity;

  const CharityCampaign({
    required this.id,
    required this.charityId,
    required this.name,
    this.imageUrl,
    required this.status,
    this.giftType,
    this.beneficiary,
    this.infoUrl,
    this.startedAt,
    this.endedAt,
    this.charity,
    required this.gratefulMessage,
  });

  @override
  List<Object?> get props => [id, name, giftType, beneficiary];

  factory CharityCampaign.fromJson(Map<String, dynamic> json) => _$CharityCampaignFromJson(json);

  Map<String, dynamic> toJson() => _$CharityCampaignToJson(this);
}
