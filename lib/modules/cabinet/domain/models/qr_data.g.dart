// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrData _$QrDataFromJson(Map<String, dynamic> json) => QrData(
      product: json['product'] as String,
      version: json['version'] as int,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      otp: json['otp'] as String?,
    );

Map<String, dynamic> _$QrDataToJson(QrData instance) => <String, dynamic>{
      'product': instance.product,
      'version': instance.version,
      'type': instance.type,
      'data': instance.data,
      'otp': instance.otp,
    };
