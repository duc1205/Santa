// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'momo_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomoPayment _$MomoPaymentFromJson(Map<String, dynamic> json) => MomoPayment(
      id: json['id'] as int,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      deepLink: json['deepLink'] as String?,
      payUrl: json['payUrl'] as String?,
      type: json['type'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
    );

Map<String, dynamic> _$MomoPaymentToJson(MomoPayment instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'orderId': instance.orderId,
      'payUrl': instance.payUrl,
      'deepLink': instance.deepLink,
      'qrCodeUrl': instance.qrCodeUrl,
      'type': instance.type,
      'redirectUrl': instance.redirectUrl,
    };
