// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProduct _$PaymentProductFromJson(Map<String, dynamic> json) => PaymentProduct(
      id: json['id'] as int,
      value: json['value'] as int,
      price: json['price'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentProductToJson(PaymentProduct instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'price': instance.price,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
