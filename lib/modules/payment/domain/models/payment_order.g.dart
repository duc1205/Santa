// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentOrder _$PaymentOrderFromJson(Map<String, dynamic> json) => PaymentOrder(
      id: json['id'] as int,
      orderId: json['uuid'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status'], unknownValue: PaymentStatus.unknown),
      amount: json['amount'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      productData: json['product_data'] == null ? null : PaymentProductData.fromJson(json['product_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentOrderToJson(PaymentOrder instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.orderId,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'product_data': instance.productData?.toJson(),
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.unknown: 'unknown',
  PaymentStatus.create: 'created',
  PaymentStatus.fail: 'failed',
  PaymentStatus.success: 'captured',
};
