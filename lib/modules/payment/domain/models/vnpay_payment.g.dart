// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vnpay_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VnPayPayment _$VnPayPaymentFromJson(Map<String, dynamic> json) => VnPayPayment(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      payUrl: json['payUrl'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
    );

Map<String, dynamic> _$VnPayPaymentToJson(VnPayPayment instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'orderId': instance.orderId,
      'payUrl': instance.payUrl,
      'redirectUrl': instance.redirectUrl,
    };
