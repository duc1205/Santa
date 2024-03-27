// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charity_donation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharityDonation _$CharityDonationFromJson(Map<String, dynamic> json) => CharityDonation(
      donorId: json['donor_id'] as int,
      charityId: json['charity_id'] as String,
      charityCampaignId: json['charity_campaign_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      donor: json['donor'] == null ? null : User.fromJson(json['donor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharityDonationToJson(CharityDonation instance) => <String, dynamic>{
      'donor_id': instance.donorId,
      'charity_id': instance.charityId,
      'charity_campaign_id': instance.charityCampaignId,
      'created_at': instance.createdAt.toIso8601String(),
      'donor': instance.donor?.toJson(),
    };
