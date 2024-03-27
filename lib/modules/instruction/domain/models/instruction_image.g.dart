// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructionImage _$InstructionImageFromJson(Map<String, dynamic> json) => InstructionImage(
      id: json['id'] as int,
      url: json['url'] as String?,
      locale: json['locale'] as String?,
      position: json['position'] as int?,
      instructionId: json['instruction_id'] as int,
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$InstructionImageToJson(InstructionImage instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'locale': instance.locale,
      'position': instance.position,
      'instruction_id': instance.instructionId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
