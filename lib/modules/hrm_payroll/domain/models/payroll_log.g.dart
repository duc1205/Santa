// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollLog _$PayrollLogFromJson(Map<String, dynamic> json) => PayrollLog(
      id: json['id'] as String,
      amount: json['amount'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PayrollLogToJson(PayrollLog instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'created_at': instance.createdAt.toIso8601String(),
    };
