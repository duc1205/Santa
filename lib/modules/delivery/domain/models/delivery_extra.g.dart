// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_extra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryExtra _$DeliveryExtraFromJson(Map<String, dynamic> json) => DeliveryExtra(
      pocketExtra: json['pocket'] == null ? null : PocketExtra.fromJson(json['pocket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryExtraToJson(DeliveryExtra instance) => <String, dynamic>{
      'pocket': instance.pocketExtra?.toJson(),
    };
