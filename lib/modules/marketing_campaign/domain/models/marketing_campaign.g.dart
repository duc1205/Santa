// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketing_campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketingCampaign _$MarketingCampaignFromJson(Map<String, dynamic> json) => MarketingCampaign(
      id: json['id'] as int,
      name: json['name'] as String?,
      bannerUrl: json['app_banner_url'] as String?,
      popupUrl: json['app_popup_url'] as String?,
      postUrl: json['post_url'] as String?,
      startedAt: json['started_at'] == null ? null : DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null ? null : DateTime.parse(json['ended_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
      needAccessToken: json['need_access_token'] as bool?,
    );

Map<String, dynamic> _$MarketingCampaignToJson(MarketingCampaign instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'app_banner_url': instance.bannerUrl,
      'app_popup_url': instance.popupUrl,
      'post_url': instance.postUrl,
      'started_at': instance.startedAt?.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'need_access_token': instance.needAccessToken,
    };
