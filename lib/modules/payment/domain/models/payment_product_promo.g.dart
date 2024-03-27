// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_promo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductPromo _$PaymentProductPromoFromJson(Map<String, dynamic> json) => PaymentProductPromo(
      id: json['id'] as int,
      value: json['value'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentProductPromoToJson(PaymentProductPromo instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
