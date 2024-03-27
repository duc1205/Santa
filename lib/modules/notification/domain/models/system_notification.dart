import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/notification/domain/models/notification_data.dart';
import 'package:santapocket/retrofit/converters/string_converter.dart';

part 'system_notification.g.dart';

@JsonSerializable()
@CopyWith()
class SystemNotification extends Equatable {
  @JsonKey(name: "id")
  @StringConverter()
  final String id;
  @JsonKey(name: "topic")
  final String topic;
  @JsonKey(name: "data")
  final NotificationData data;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const SystemNotification({
    required this.id,
    required this.topic,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id];

  factory SystemNotification.fromJson(Map<String, dynamic> json) => _$SystemNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$SystemNotificationToJson(this);
}
