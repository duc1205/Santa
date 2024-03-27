// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocket_pricing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PocketPricing _$PocketPricingFromJson(Map<String, dynamic> json) => PocketPricing(
      id: json['id'] as int,
      sizeId: json['size_id'] as int,
      sendingPrice: json['sending_price'] as int,
    );

Map<String, dynamic> _$PocketPricingToJson(PocketPricing instance) => <String, dynamic>{
      'id': instance.id,
      'size_id': instance.sizeId,
      'sending_price': instance.sendingPrice,
    };
