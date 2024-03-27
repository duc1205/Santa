// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charity_campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharityCampaign _$CharityCampaignFromJson(Map<String, dynamic> json) => CharityCampaign(
      id: json['id'] as String,
      charityId: json['charity_id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      status: $enumDecode(_$CharityCampaignStatusEnumMap, json['status'], unknownValue: CharityCampaignStatus.unknown),
      giftType: json['gift_type'] as String?,
      beneficiary: json['beneficiary'] as String?,
      infoUrl: json['info_url'] as String?,
      startedAt: json['started_at'] == null ? null : DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null ? null : DateTime.parse(json['ended_at'] as String),
      charity: json['charity'] == null ? null : Charity.fromJson(json['charity'] as Map<String, dynamic>),
      gratefulMessage: json['grateful_message'] as String?,
    );

Map<String, dynamic> _$CharityCampaignToJson(CharityCampaign instance) => <String, dynamic>{
      'id': instance.id,
      'charity_id': instance.charityId,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'status': _$CharityCampaignStatusEnumMap[instance.status]!,
      'gift_type': instance.giftType,
      'beneficiary': instance.beneficiary,
      'info_url': instance.infoUrl,
      'started_at': instance.startedAt?.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'grateful_message': instance.gratefulMessage,
      'charity': instance.charity?.toJson(),
    };

const _$CharityCampaignStatusEnumMap = {
  CharityCampaignStatus.unknown: 'unknown',
  CharityCampaignStatus.ready: 'ready',
  CharityCampaignStatus.finished: 'finished',
};
