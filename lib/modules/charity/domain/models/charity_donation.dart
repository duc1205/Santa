import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

part 'charity_donation.g.dart';

@JsonSerializable()
class CharityDonation extends Equatable {
  @JsonKey(name: "donor_id")
  final int donorId;
  @JsonKey(name: "charity_id")
  final String charityId;
  @JsonKey(name: "charity_campaign_id")
  final String charityCampaignId;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "donor")
  final User? donor;

  const CharityDonation({
    required this.donorId,
    required this.charityId,
    required this.charityCampaignId,
    required this.createdAt,
    this.donor,
  });

  @override
  List<Object> get props => [];

  factory CharityDonation.fromJson(Map<String, dynamic> json) => _$CharityDonationFromJson(json);

  Map<String, dynamic> toJson() => _$CharityDonationToJson(this);
}
