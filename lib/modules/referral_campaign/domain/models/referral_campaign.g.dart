// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralCampaign _$ReferralCampaignFromJson(Map<String, dynamic> json) => ReferralCampaign(
      id: json['id'] as String,
      name: json['name'] as String?,
      infoUrl: json['info_url'] as String?,
      descriptions: (json['descriptions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      startedAt: json['started_at'] == null ? null : DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null ? null : DateTime.parse(json['ended_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
      referConeReward: json['refer_cone_reward'] as int?,
      referredConeReward: json['referred_cone_reward'] as int?,
      referFreeUsageReward: json['refer_free_usage_reward'] as int?,
      referredFreeUsageReward: json['referred_free_usage_reward'] as int?,
    );

Map<String, dynamic> _$ReferralCampaignToJson(ReferralCampaign instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info_url': instance.infoUrl,
      'descriptions': instance.descriptions,
      'started_at': instance.startedAt?.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'refer_cone_reward': instance.referConeReward,
      'referred_cone_reward': instance.referredConeReward,
      'refer_free_usage_reward': instance.referFreeUsageReward,
      'referred_free_usage_reward': instance.referredFreeUsageReward,
    };
